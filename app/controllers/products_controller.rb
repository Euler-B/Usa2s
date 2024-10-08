class ProductsController < ApplicationController
  def index
    @categories = Category.order(name: :asc).load_async
    # TODO := investigar bien el async en rails

    @products = Product.all.with_attached_photo
    if params[:category_id]
      @products = @products.where(category_id: params[:category_id])
    end

    if params[:min_price].present?
      @products = @products.where("price >= ?", params[:min_price])
    end

    if params[:max_price].present?
      @products = @products.where("price <= ?", params[:max_price])
    end

    if params[:query_text].present?
      @products = @products.search_full_text(params[:query_text])
    end

    if params[:order_by].present?
      order_by = {
        "newest": "created_at DESC",
        "expensive": "price DESC",
        "cheapest": "price ASC"
      }.fetch(params[:order_by].to_sym, "created_at DESC")

      @products = @products.order(order_by)
    end
  end

  def show
    product
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to products_path, notice: t('.created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    product
  end

  def update
    if product.update(product_params)
      redirect_to products_path, notice: t('.updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    product.destroy
    redirect_to products_path, notice: t('.destroyed'), status: :see_other
  end

  private

  def product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:title, :description, :price, :photo, :category_id)
  end
end
