module Corzinus
  class OrderItemsController < ApplicationController
    def create
      AddOrderItem.call(current_order, params) do
        on(:valid) do |quantity|
          flash[:notice] = t('corzinus.flash.success.product_add', count: quantity)
        end
        on(:invalid) do |errors|
          flash[:alert] = t('corzinus.flash.failure.product_add', errors: errors)
        end
      end
      redirect_back(fallback_location: root_path)
    end

    def destroy
      order_item = OrderItem.find(params[:id])
      if order_item.destroy && current_order.save
        flash[:notice] = t('corzinus.flash.success.product_destroy',
                           title: order_item.productable.title)
      else
        flash[:alert] = t('corzinus.flash.failure.product_destroy',
                          errors: order_item.decorate.all_errors)
      end
      redirect_back(fallback_location: edit_cart_path)
    end
  end
end
