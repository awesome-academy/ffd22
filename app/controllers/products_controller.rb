class ProductsController < ApplicationController
  before_action :logged_in_user, :admin_user,
    only: %i(new create edit update destroy)
  before_action :load_product, except: %i(create new index)
  before_action :load_list_products, only: :index

  def index
    flash.now[:danger] = t ".no_product" if @products.blank?
  end

  def new
    @product = Product.new
  end

  def show
    @comment = Comment.new
    @comments = @product.comments.order(created_at: :desc)
  end

  def create
    @product = Product.new product_params
    if @product.save
      flash[:info] = t "controllers.products.product_created"
      redirect_to @product
    else
      render :new
    end
  end

  def edit; end

  def update
    if @product.update_attributes product_params
      flash[:success] = t ".product_updated"
      redirect_to @product
    else
      render :edit
    end
  end

  def destroy
    if @product.destroy
      flash[:success] = t ".product_deleted"
    else
      flash[:danger] = t ".product_delete_failed"
    end
    redirect_to products_path
  end

  private

  def load_product
    @product = Product.find_by id: params[:id]
    return if @product
    flash[:danger] = t "controllers.products.product_not_found"
    redirect_to root_path
  end

  def product_params
    params.require(:product).permit :name, :image, :price, :information,
      :classify, :quantity, :category_id
  end

  def load_list_products
    @products = if filter_params.size.positive?
                  Product.filter_products(filter_params)
                         .order_desc.paginate page: params[:page],
                           per_page: Settings.per_page.products
                else
                  Product.order_desc.paginate page: params[:page],
                    per_page: Settings.per_page.products
                end
  end

  def filter_params
    filter_params = params.permit(:classify, :category_id).to_h
    if params[:price].present?
      price = params[:price].split("..")
      filter_params[:price] = price[0]..price[1]
    end
    filter_params.reject{|_k, v| v.blank?}
  end
end
