module Corzinus
  module Checkout
    class ConfirmAccessService < AccessService
      def valid?
        order.processing?
      end
    end
  end
end
