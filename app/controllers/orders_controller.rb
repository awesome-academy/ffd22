class OrdersController < ApplicationController
  before_action :authenticate_user!, only: %i(index show destroy)
  before_action :load_order, only: %i(show update destroy)
  before_action :check_quantity_available, :check_cart_products, only: :create
  before_action :load_list_orders, only: :index
  authorize_resource except: :destroy

  def show
    if @order.user_id == current_user.id
      @order_products = @order.order_products
    else
      redirect_to root_path
    end
  end

  def index
    return if @orders
    flash[:danger] = t ".controllers.you_have_no_order"
    redirect_to products_path
  end

  def create
    @order = current_user.orders.build(total_price: calculate_total_price)
    load_cart_to_order
    return unless @order.save
    cookies.delete current_user.id
    flash[:success] = t "orders.controllers.order_created"
    redirect_to @order
  end

  def update
    @order.update_attributes status: params[:order][:status].to_i
  end

  def destroy
    authorize! :destroy, @order, message: t("orders.controllers.you_cant_cancel")
    if (@order.user_id == current_user.id || admin_user?) && @order.destroy
      flash[:success] = t "orders.controllers.order_deleted"
    else
      flash[:danger] = t "orders.controllers.can_not_delete"
    end
    redirect_to orders_path
  end

  private

  def load_order
    @order = Order.find_by id: params[:id]
    return if @order
    flash[:danger] = t "orders.controllers.order_not_found"
    redirect_to root_path
  end

  def load_list_orders
    @orders = if current_user.admin?
                Order.order_day_desc.paginate page: params[:page],
                per_page: Settings.per_page.orders
              else
                current_user.orders.order_day_desc.paginate page: params[:page],
                per_page: Settings.per_page.orders
              end
  end

  def load_cart_to_order
    cart_products.each do |product_id, quantity|
      product = find_product product_id
      order_products = @order.order_products.build(product_id: product_id,
        quantity: quantity, price: product.price)
      order_products.save
      change_quantity_product product, quantity
    end
  end

  def check_quantity_available
    have_error = false
    cart_products.each do |product_id, quantity|
      product = find_product product_id
      if product.quantity < quantity.to_i
        have_error = true
        break
      end
    end
    return unless have_error
    flash[:danger] = t ".controllers.enter_another_quantity"
    redirect_to carts_path
  end

  def check_cart_products
    return if cart_products.present?
    flash[:danger] = t ".controllers.your_cart_blank"
    redirect_to carts_path
  end

  def change_quantity_product product, quantity
    product.update_attributes quantity: product.quantity - quantity.to_i
  end
end
