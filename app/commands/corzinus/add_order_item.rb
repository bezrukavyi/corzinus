module Corzinus
  class AddOrderItem < Rectify::Command
    attr_reader :order, :params, :quantity

    def initialize(order, params)
      @order = order
      @params = params
      @quantity = params[:quantity].to_i
    end

    def call
      if added_item.valid? && order.save
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

    def added_item
      @added_item ||= order.add_item!(productable, quantity)
    end

    def item_errors
      added_item.decorate.all_errors if added_item.present?
    end
  end
end
