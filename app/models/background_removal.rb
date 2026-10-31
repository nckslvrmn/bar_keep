class BackgroundRemoval
  # Every channel must reach this to count as background. Pairs with BraveImageSearch::BACKGROUND_HINT.
  WHITE_THRESHOLD = 235
  BACKGROUND = 128
  EDGE_SOFTENING = 0.8

  # Only white connected to the border is removed, so white labels and glass inside the subject survive.
  def self.apply(attachable)
    image = Vips::Image.new_from_buffer(attachable[:io].read, "").autorot.colourspace(:srgb)
    image = image.flatten(background: 255) if image.has_alpha?
    width, height = image.width, image.height

    # A white frame joins every edge region so a single flood from the corner reaches all of them.
    white = (image >= WHITE_THRESHOLD).bandand.embed(1, 1, width + 2, height + 2, extend: :white)
    flooded = white.mutate { |mask| mask.draw_flood!(BACKGROUND, 0, 0, equal: true) }
    alpha = (flooded.crop(1, 1, width, height) == BACKGROUND).invert.gaussblur(EDGE_SOFTENING)

    {
      io: StringIO.new(image.bandjoin(alpha).pngsave_buffer),
      filename: "#{File.basename(attachable[:filename].to_s, ".*")}.png",
      content_type: "image/png"
    }
  end
end
