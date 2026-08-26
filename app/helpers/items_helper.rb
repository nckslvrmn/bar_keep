module ItemsHelper
  FILTER_KEYS = [ :search, :item_type, :stock_status, :category_match, :sort ].freeze

  def current_filters
    params.permit(*FILTER_KEYS, category_ids: []).to_h.symbolize_keys
  end

  def filter_url(overrides = {})
    items_path(current_filters.merge(overrides).compact_blank)
  end

  def filters_active?
    current_filters.except(:category_match, :sort).any? { |_key, value| value.present? }
  end

  THUMBNAIL_LIMIT = [ 320, 320 ].freeze
  DETAIL_LIMIT = [ 800, 800 ].freeze

  def optimized_item_image(item, options = {})
    return unless item.image.attached?

    image_tag item.image.variant(resize_to_limit: DETAIL_LIMIT, format: :webp),
      { loading: "lazy", decoding: "async", class: "item-image" }.merge(options)
  end

  def item_thumbnail(item, options = {})
    content_tag :div, class: "item-thumbnail d-flex align-items-center justify-content-center" do
      if item.image.attached?
        image_tag item.image.variant(resize_to_limit: THUMBNAIL_LIMIT, format: :webp),
          options.merge(class: "w-100 h-100", style: "object-fit: contain;", loading: "lazy", decoding: "async")
      else
        content_tag :span, "📷"
      end
    end
  end
end
