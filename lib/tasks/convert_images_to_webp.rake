namespace :images do
  desc "Convert all existing item images to WebP format"
  task convert_to_webp: :environment do
    puts "Starting image conversion to WebP..."

    converted_count = 0
    failed_count = 0
    already_webp_count = 0

    # Find all items with attached images
    Item.includes(image_attachment: :blob).find_each do |item|
      next unless item.image.attached?

      blob = item.image.blob

      # Skip if already WebP
      if blob.content_type == "image/webp"
        already_webp_count += 1
        next
      end

      begin
        puts "Converting image for item: #{item.name} (ID: #{item.id})"

        # Download the current image
        image_data = blob.download

        # Create a temp file for the original image
        temp_original = Tempfile.new([ "original", File.extname(blob.filename.to_s) ])
        temp_original.binmode
        temp_original.write(image_data)
        temp_original.rewind

        # Create a temp file for the converted image
        temp_webp = Tempfile.new([ "converted", ".webp" ])

        # Convert to WebP using MiniMagick
        image = MiniMagick::Image.open(temp_original.path)
        image.format "webp"
        image.quality 85
        image.write temp_webp.path

        # Create a new blob with the WebP data
        new_blob = ActiveStorage::Blob.create_and_upload!(
          io: File.open(temp_webp.path),
          filename: blob.filename.base + ".webp",
          content_type: "image/webp"
        )

        # Attach the new blob to the item
        item.image.attach(new_blob)

        # Delete the old blob (optional - you might want to keep originals)
        # blob.purge_later

        converted_count += 1
        puts "  ✓ Converted successfully"

      rescue => e
        failed_count += 1
        puts "  ✗ Failed to convert: #{e.message}"
      ensure
        temp_original&.close
        temp_original&.unlink
        temp_webp&.close
        temp_webp&.unlink
      end
    end

    puts "\nConversion complete!"
    puts "  - Converted: #{converted_count} images"
    puts "  - Already WebP: #{already_webp_count} images"
    puts "  - Failed: #{failed_count} images"
  end

  desc "Check image formats in the database"
  task check_formats: :environment do
    format_counts = Hash.new(0)

    Item.includes(image_attachment: :blob).find_each do |item|
      next unless item.image.attached?

      format_counts[item.image.blob.content_type] += 1
    end

    puts "\nCurrent image formats:"
    format_counts.each do |format, count|
      puts "  #{format}: #{count} images"
    end
    puts "  Total: #{format_counts.values.sum} images"
  end
end
