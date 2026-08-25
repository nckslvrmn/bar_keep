module ItemsHelper
  FILTER_KEYS = [ :search, :item_type, :stock_status, :category_match ].freeze

  def current_filters
    params.permit(*FILTER_KEYS, category_ids: []).to_h.symbolize_keys
  end

  def filter_url(overrides = {})
    items_path(current_filters.merge(overrides).compact_blank)
  end

  def filters_active?
    current_filters.except(:category_match).any? { |_key, value| value.present? }
  end

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
        variant = item.image.variant(resize_to_limit: [ 150, 150 ])
        image_tag variant, options.merge(class: "w-100 h-100", style: "object-fit: contain;", loading: "lazy", width: 150, height: 150)
      else
        content_tag :span, "📷"
      end
    end
  end

  def item_detail_image(item, options = {})
    return unless item.image.attached?

    variant = item.image.variant(resize_to_limit: [ 800, 800 ])
    image_tag variant, options.merge(loading: "lazy", class: options[:class] || "item-detail-image")
  end
end
