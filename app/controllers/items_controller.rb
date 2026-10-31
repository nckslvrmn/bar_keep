class ItemsController < ApplicationController
  before_action :set_item, only: [ :show, :edit, :update, :destroy, :increment, :decrement, :set_quantity ]
  before_action :load_categories, only: [ :new, :edit, :create, :update ]
  before_action :restrict_guest_access, only: [ :new, :create, :edit, :update, :destroy, :increment, :decrement, :set_quantity, :image_search ]

  def index
    @items = filtered_items.includes(:categories, :user, image_attachment: :blob).sorted_by(params[:sort])
    @categories = Category.all.order(:name)
    @category_counts = @items.flat_map(&:category_ids).tally
  end

  def show
    @metadata = @item.metadata_hash
  end

  def new
    @item = current_user.items.build
    @item.quantity = 1
    @item.low_stock_threshold = 0
    @metadata = {}
  end

  def create
    @item = current_user.items.build(item_params)

    if @item.save
      @item.update_metadata(params[:metadata]) if params[:metadata].present?
      redirect_to @item, notice: "Item was successfully created."
    else
      @metadata = submitted_metadata
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @metadata = @item.metadata_hash
  end

  def update
    if @item.update(item_params)
      Category.delete_orphaned
      @item.update_metadata(params[:metadata]) if params[:metadata].present?
      redirect_to @item, notice: "Item was successfully updated."
    else
      @metadata = submitted_metadata
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy
    Category.delete_orphaned
    redirect_to items_url, notice: "Item was successfully destroyed."
  end

  def increment
    @item.increment_quantity!(params[:amount]&.to_i || 1)
    redirect_back fallback_location: items_path, status: :see_other
  end

  def decrement
    @item.decrement_quantity!(params[:amount]&.to_i || 1)
    redirect_back fallback_location: items_path, status: :see_other
  end

  def set_quantity
    @item.set_quantity!(params[:quantity])
    redirect_back fallback_location: items_path, status: :see_other
  end

  def image_search
    return head :not_found unless BraveImageSearch.enabled?

    render json: BraveImageSearch.search(params.expect(:q))
  rescue BraveImageSearch::Error => e
    Rails.logger.warn("Brave image search failed: #{e.message}")
    render json: { error: "Image search failed." }, status: :bad_gateway
  end

  private

  def filtered_items
    @filtered_items ||= begin
      scope = current_user.guest? ? Item.all : current_user.items
      category_ids = Array(params[:category_ids]).map(&:to_i).select(&:positive?)

      scope.by_categories(category_ids, match_all: params[:category_match] == "all")
           .by_type(params[:item_type])
           .by_stock_status(params[:stock_status])
           .search(params[:search])
    end
  end

  def set_item
    # Guest users can view all items, regular users only their own
    if current_user.guest?
      @item = Item.find(params[:id])
    else
      @item = current_user.items.find(params[:id])
    end
  end

  def load_categories
    @categories = Category.all.order(:name)
  end

  def restrict_guest_access
    if current_user.guest?
      redirect_to items_path, alert: "Guest accounts have read-only access."
    end
  end

  def submitted_metadata
    params.fetch(:metadata, {}).to_unsafe_h.transform_values(&:to_s).compact_blank
  end

  def item_params
    params.expect(item: [ :name, :quantity, :low_stock_threshold, :item_type, :image, :remove_image, :category_names, image_urls: [] ])
  end
end
