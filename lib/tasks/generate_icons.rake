require "mini_magick"
require "tempfile"

namespace :icons do
  desc "Generate PNG icons from SVG"
  task generate: :environment do
    svg_file = Rails.root.join("public", "icon.svg")

    unless File.exist?(svg_file)
      puts "❌ SVG file not found at #{svg_file}"
      return
    end

    sizes = [ 120, 152, 180, 192, 512 ]
    has_rsvg = system("which rsvg-convert > /dev/null 2>&1")

    puts "🎨 Generating icons from #{svg_file}..."
    puts "   Using #{has_rsvg ? 'rsvg-convert' : 'ImageMagick'} for SVG rendering\n\n"

    if has_rsvg
      temp_file = Tempfile.new([ "icon", ".png" ])
      begin
        system("rsvg-convert -w 1024 -h 1024 #{svg_file} -o #{temp_file.path}")

        sizes.each do |size|
          generate_icon_from_png(temp_file.path, size)
        end

        generate_icon_from_png(temp_file.path, 192, "icon.png")

      ensure
        temp_file.close
        temp_file.unlink
      end
    else
      sizes.each do |size|
        generate_icon_from_svg(svg_file, size)
      end

      generate_icon_from_svg(svg_file, 192, "icon.png")
    end

    generate_favicon

    puts "\n✅ Icon generation complete!"

    unless has_rsvg
      puts "\n💡 Tip: For better gradient rendering, install rsvg-convert:"
      puts "   brew install librsvg"
    end
  end

  private

  def generate_icon_from_png(source, size, filename = nil)
    output_file = Rails.root.join("public", filename || "icon-#{size}.png")

    MiniMagick::Tool::Magick.new do |magick|
      magick << source
      magick << "-resize" << "#{size}x#{size}"
      magick << "-gravity" << "center"
      magick << "-extent" << "#{size}x#{size}"
      magick << "-strip"
      magick << "-quality" << "100"
      magick << output_file.to_s
    end

    puts "   ✓ #{size}x#{size} → #{File.basename(output_file)}"
  rescue => e
    puts "   ✗ Failed #{size}x#{size}: #{e.message}"
  end

  def generate_icon_from_svg(source, size, filename = nil)
    output_file = Rails.root.join("public", filename || "icon-#{size}.png")

    MiniMagick::Tool::Magick.new do |magick|
      magick << "-density" << "600"
      magick << "-background" << "transparent"
      magick << "-colorspace" << "sRGB"
      magick << source.to_s
      magick << "-resize" << "#{size}x#{size}"
      magick << "-gravity" << "center"
      magick << "-extent" << "#{size}x#{size}"
      magick << "-strip"
      magick << "-quality" << "100"
      magick << output_file.to_s
    end

    puts "   ✓ #{size}x#{size} → #{File.basename(output_file)}"
  rescue => e
    puts "   ✗ Failed #{size}x#{size}: #{e.message}"
  end

  def generate_favicon
    MiniMagick::Tool::Magick.new do |magick|
      magick << "-background" << "transparent"
      magick << Rails.root.join("public", "icon.png").to_s
      magick << "-resize" << "32x32"
      magick << "-gravity" << "center"
      magick << "-extent" << "32x32"
      magick << Rails.root.join("public", "favicon.ico").to_s
    end

    puts "   ✓ 32x32 → favicon.ico"
  rescue => e
    puts "   ✗ Failed favicon: #{e.message}"
  end
end
