module Corzinus
  module Checkout
    class DeliveryAccessService < AccessService
      def valid?
        order.delivery.present?
      end
    end
  end
end
