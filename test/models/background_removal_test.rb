require "test_helper"

class BackgroundRemovalTest < ActiveSupport::TestCase
  test "white connected to the edges becomes transparent" do
    image = removed(framed_square)

    assert_equal 4, image.bands
    assert_equal 0, image.getpoint(0, 0).last
    assert_equal 0, image.getpoint(19, 19).last
  end

  test "white enclosed by the subject stays opaque" do
    image = removed(framed_square)

    assert_equal 255, image.getpoint(10, 10).last
    assert_equal [ 255, 255, 255 ], image.getpoint(10, 10).first(3)
  end

  test "the result is a png" do
    result = BackgroundRemoval.apply(attachable(framed_square))

    assert_equal "image/png", result[:content_type]
    assert_equal "bottle.png", result[:filename]
  end

  test "undecodable data raises a vips error" do
    assert_raises(Vips::Error) do
      BackgroundRemoval.apply({ io: StringIO.new("not an image"), filename: "bottle.jpg", content_type: "image/jpeg" })
    end
  end

  private

  def framed_square
    white = Vips::Image.black(20, 20).invert.bandjoin([ 255, 255 ])
    white.mutate { |image| image.draw_rect!([ 0, 0, 0 ], 5, 5, 10, 10, fill: false) }
  end

  def attachable(image)
    { io: StringIO.new(image.jpegsave_buffer(Q: 100)), filename: "bottle.jpg", content_type: "image/jpeg" }
  end

  def removed(image)
    Vips::Image.new_from_buffer(BackgroundRemoval.apply(attachable(image))[:io].read, "")
  end
end
