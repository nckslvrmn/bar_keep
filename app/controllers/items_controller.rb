# typed: true

class ItemsController < ApplicationController
  extend T::Sig

  include ImageProcessingConcern

  before_action :set_item, only: [ :show, :edit, :update, :destroy, :increment, :decrement ]
  before_action :load_categories, only: [ :new, :edit, :create, :update ]
  before_action :restrict_guest_access, only: [ :new, :create, :edit, :update, :destroy, :increment, :decrement ]

  def index
    # Guest users see all items, regular users see only their own items
    items_scope = current_user.guest? ? Item.all : current_user.items

    @items = items_scope.includes(:categories, :user, image_attachment: :blob)
                 .by_categories(params[:category_ids], match_all: params[:category_match] == "all")
                 .by_type(params[:item_type])
                 .by_stock_status(params[:stock_status])
                 .search(params[:search])
                 .order(:name)

    @categories = Category.all.order(:name)
  end

  def show
    @metadata = @item.metadata_hash
  end

  def new
    @item = current_user.items.build
    @item.quantity = 1
    @item.low_stock_threshold = 0
  end

  def create
    process_image_params(:item)

    @item = current_user.items.build(item_params.except(:category_names))

    if @item.save
      handle_categories(@item, params[:item][:category_names])

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
      handle_categories(@item, params[:item][:category_names])

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

    respond_to do |format|
      format.turbo_stream { render :update_quantity }
      format.html { redirect_back(fallback_location: items_path, notice: "Quantity increased.") }
    end
  end

  def decrement
    @item.decrement_quantity!(params[:amount]&.to_i || 1)

    respond_to do |format|
      format.turbo_stream { render :update_quantity }
      format.html { redirect_back(fallback_location: items_path, notice: "Quantity decreased.") }
    end
  end

  private

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

  def handle_categories(item, category_names_string)
    return unless category_names_string.present?

    category_names = category_names_string.split(",").map(&:strip).reject(&:blank?)
    return if category_names.empty?

    existing_categories = Category.where(name: category_names).index_by(&:name)
    new_category_names = category_names - existing_categories.keys

    if new_category_names.any?
      new_categories = new_category_names.map do |name|
        Category.create!(name: name, slug: name.parameterize)
      end
      new_categories.each { |cat| existing_categories[cat.name] = cat }
    end

    item.categories = category_names.map { |name| existing_categories[name] }.compact
  end

  def item_params
    params.require(:item).permit(:name, :quantity, :low_stock_threshold, :item_type, :image, :category_names)
  end
end
