module ItemsHelper
  def optimized_item_image(item, options = {})
    return unless item.image.attached?

    # Default options
    default_options = {
      loading: "lazy",
      class: options[:class] || "item-image"
    }

    # Merge with provided options
    image_options = default_options.merge(options)

    # For WebP images, use them directly
    # For other formats, Active Storage will handle variant generation
    image_tag item.image, image_options
  end

  def item_thumbnail(item, options = {})
    if item.image.attached?
      content_tag :div, class: "item-thumbnail d-flex align-items-center justify-content-center" do
        optimized_item_image(item, options.merge(class: "w-100 h-100", style: "object-fit: contain;"))
      end
    else
      content_tag :div, class: "item-thumbnail bg-secondary d-flex align-items-center justify-content-center" do
        content_tag :span, "📷"
      end
    end
  end
end
