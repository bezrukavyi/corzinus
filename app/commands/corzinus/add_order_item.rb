module Corzinus
  class AddOrderItem < Rectify::Command
    attr_reader :order, :params, :quantity

    def initialize(order, params)
      @order = order
      @params = params
      @quantity = params[:quantity].to_i
    end

    def call
      if order_item.try(:save) && order.save
        broadcast :valid, quantity
      else
        broadcast :invalid, item_errors
      end
    end

    private

    def productable
      product_class = params[:productable_type].classify.constantize
      @productable = product_class.find_by(id: params[:productable_id])
    end

    def order_item
      @order_item ||= order.add_item(productable, quantity)
    end

    def item_errors
      order_item.decorate.all_errors if order_item.present?
    end
  end
end
