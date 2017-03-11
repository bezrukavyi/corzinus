module Corzinus
  module Checkout
    class CompleteAccessService < AccessService
      def allow?
        return true if order.items_count.zero?
        super && order.in_progress?
      end
    end
  end
end
