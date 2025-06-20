class ItemsController < ApplicationController
  include ImageProcessingConcern

  before_action :set_item, only: [ :show, :edit, :update, :destroy, :increment, :decrement ]
  before_action :load_categories, only: [ :new, :edit, :create, :update ]

  def index
    @items = Item.includes(:categories, image_attachment: :blob)

    # Filter by categories (multiple)
    if params[:category_ids].present? && params[:category_ids].is_a?(Array)
      if params[:category_match] == "all"
        # Find items that have ALL of the selected categories
        item_ids = Item.joins(:categories)
                       .where(categories: { id: params[:category_ids] })
                       .group("items.id")
                       .having("COUNT(DISTINCT categories.id) = ?", params[:category_ids].length)
                       .pluck(:id)
        @items = @items.where(id: item_ids)
      else
        # Default: Find items that have ANY of the selected categories
        item_ids = Item.joins(:categories).where(categories: { id: params[:category_ids] }).pluck(:id).uniq
        @items = @items.where(id: item_ids)
      end
    end

    # Filter by item type
    if params[:item_type].present?
      @items = @items.where(item_type: params[:item_type])
    end

    # Filter by stock status
    if params[:stock_status].present?
      case params[:stock_status]
      when "out_of_stock"
        @items = @items.out_of_stock
      when "low_stock"
        @items = @items.low_stock
      when "in_stock"
        @items = @items.in_stock
      end
    end

    # Search by name
    if params[:search].present?
      @items = @items.where("items.name LIKE ?", "%#{params[:search]}%")
    end

    @items = @items.distinct.order(:name)
    @categories = Category.all.order(:name)
  end

  def show
    @metadata = @item.metadata_hash
  end

  def new
    @item = Item.new
    @item.quantity = 1
    @item.low_stock_threshold = 0
  end

  def create
    process_image_params(:item)

    @item = Item.new(item_params.except(:category_names))

    if @item.save
      # Handle categories
      handle_categories(@item, params[:item][:category_names])

      # Handle metadata
      if params[:metadata].present?
        @item.update_metadata(params[:metadata])
      end

      redirect_to @item, notice: "Item was successfully created."
    else
      render :new
    end
  end

  def edit
    @metadata = @item.metadata_hash
  end

  def update
    process_image_params(:item)

    if @item.update(item_params.except(:category_names))
      # Handle categories
      handle_categories(@item, params[:item][:category_names])

      # Handle metadata
      if params[:metadata].present?
        @item.update_metadata(params[:metadata])
      end

      redirect_to @item, notice: "Item was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @item.destroy
    redirect_to items_url, notice: "Item was successfully destroyed."
  end

  def increment
    @item.increment_quantity!(params[:amount]&.to_i || 1)
    redirect_back(fallback_location: items_path, notice: "Quantity increased.")
  end

  def decrement
    @item.decrement_quantity!(params[:amount]&.to_i || 1)
    redirect_back(fallback_location: items_path, notice: "Quantity decreased.")
  end

  def restocking
    @items = Item.needs_restocking.includes(:categories, image_attachment: :blob).order(:name)
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def load_categories
    @categories = Category.all.order(:name)
  end

  def handle_categories(item, category_names_string)
    return unless category_names_string.present?

    # Clear existing categories
    item.categories.clear

    # Parse comma-separated category names
    category_names = category_names_string.split(",").map(&:strip).reject(&:blank?)

    # Find or create each category and add to item
    category_names.each do |name|
      category = Category.find_or_create_by(name: name)
      item.categories << category unless item.categories.include?(category)
    end
  end

  def item_params
    params.require(:item).permit(:name, :quantity, :low_stock_threshold, :item_type, :image, :category_names)
  end
end
