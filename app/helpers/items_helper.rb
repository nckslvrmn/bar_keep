# typed: true

module ItemsHelper
  extend T::Sig
  def optimized_item_image(item, options = {})
    return unless item.image.attached?

    default_options = {
      loading: "lazy",
      class: options[:class] || "item-image"
    }

    image_tag item.image, default_options.merge(options)
  end

  def item_thumbnail(item, options = {})
    content_tag :div, class: "item-thumbnail d-flex align-items-center justify-content-center" do
      if item.image.attached?
        optimized_item_image(item, options.merge(class: "w-100 h-100", style: "object-fit: contain;"))
      else
        content_tag :span, "📷"
      end
    end
  end
end
