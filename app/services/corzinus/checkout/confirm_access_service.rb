module Corzinus
  module Checkout
    class ConfirmAccessService < AccessService
      def valid?
        order.in_progress?
      end
    end
  end
end
