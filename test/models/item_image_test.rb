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

  test "an image url is downloaded and attached" do
    item = items(:low_stock_syrup)
    item.image_urls = [ "https://example.com/bottle.png" ]

    stub_class_method(RemoteImage, :fetch, ->(_url) { png_attachable }) do
      assert item.save
    end
    assert item.reload.image.attached?
  end

  test "the next url is tried when a download fails" do
    item = items(:low_stock_syrup)
    item.image_urls = [ "https://example.com/blocked.png", "https://imgs.search.brave.com/thumb" ]
    fetch = ->(url) { url.include?("blocked") ? raise(RemoteImage::Error, "403") : png_attachable }

    stub_class_method(RemoteImage, :fetch, fetch) do
      assert item.save
    end
    assert item.reload.image.attached?
  end

  test "the item is invalid when no url downloads" do
    item = items(:low_stock_syrup)
    item.image_urls = [ "https://example.com/blocked.png" ]

    stub_class_method(RemoteImage, :fetch, ->(_url) { raise RemoteImage::Error, "403" }) do
      assert_not item.save
    end
    assert_includes item.errors[:image].join, "could not be downloaded"
  end

  test "an uploaded file wins over image urls" do
    item = items(:low_stock_syrup)
    item.image = png_attachable.merge(filename: "upload.png")
    item.image_urls = [ "https://example.com/bottle.png" ]

    stub_class_method(RemoteImage, :fetch, ->(_url) { flunk "should not download" }) do
      assert item.save
    end
    assert_equal "upload.png", item.reload.image.filename.to_s
  end

  test "a new upload wins over remove image" do
    @item.image = png_attachable.merge(filename: "replacement.png")
    @item.remove_image = true

    assert @item.save
    assert_equal "replacement.png", @item.reload.image.filename.to_s
  end

  private

  def png_attachable
    { io: StringIO.new(Rails.root.join("public/icon-192.png").binread), filename: "bottle.png", content_type: "image/png" }
  end
end
