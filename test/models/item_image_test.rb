require "test_helper"

class ItemImageTest < ActiveSupport::TestCase
  setup do
    @item = items(:bourbon)
    @item.image.attach(
      io: Rails.root.join("public/icon-192.png").open,
      filename: "icon.png",
      content_type: "image/png"
    )
  end

  test "the original upload is stored untouched" do
    assert_equal "image/png", @item.image.blob.content_type
  end

  test "thumbnails are generated as webp" do
    variant = @item.image.variant(resize_to_limit: ItemsHelper::THUMBNAIL_LIMIT, format: :webp).processed

    assert_equal "image/webp", variant.image.blob.content_type
    assert variant.image.blob.byte_size.positive?
  end

  test "detail images are generated as webp" do
    variant = @item.image.variant(resize_to_limit: ItemsHelper::DETAIL_LIMIT, format: :webp).processed

    assert_equal "image/webp", variant.image.blob.content_type
  end
end
