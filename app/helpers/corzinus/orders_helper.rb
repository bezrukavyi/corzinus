module Corzinus
  module OrdersHelper
    def use_base_address_param
      current_order.use_base_address || params[:use_base_address]
    end

    def coupon_options(field)
      return {} if field.object.errors.present?
      { input_html: { value: '' } }
    end
  end
end
