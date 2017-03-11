module Corzinus
  module Checkout
    class PaymentAccessService < AccessService
      def valid?
        order.credit_card.present?
      end
    end
  end
end
