module Corzinus
  module CouponsHelper
    def coupon_options(field)
      return {} if field.object.errors.present?
      { input_html: { value: '' } }
    end
  end
end
