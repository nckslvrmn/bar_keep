# typed: false

module ImageProcessingConcern
  extend ActiveSupport::Concern

  included do
    helper_method :process_image_params
  end

  private

  def process_image_params(params_key, image_field = :image)
    return unless params[params_key] && params[params_key][image_field]

    image = params[params_key][image_field]

    if image.is_a?(ActionDispatch::Http::UploadedFile) && image.content_type != "image/webp"
      converted_image = convert_to_webp(image)
      params[params_key][image_field] = converted_image if converted_image
    end
  end

  def convert_to_webp(uploaded_file)
    temp_file = Tempfile.new([ "converted", ".webp" ])

    begin
      image = MiniMagick::Image.open(uploaded_file.tempfile.path)

      image.format "webp"
      image.quality 85
      image.write temp_file.path

      ActionDispatch::Http::UploadedFile.new(
        filename: File.basename(uploaded_file.original_filename, ".*") + ".webp",
        type: "image/webp",
        tempfile: temp_file
      )
    rescue => e
      Rails.logger.error "Failed to convert image to WebP: #{e.message}"
      temp_file.close
      temp_file.unlink
      nil
    end
  end
end
