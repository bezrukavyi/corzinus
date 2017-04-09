module Corzinus
  module Checkout
    class AccessStep < Rectify::Command
      attr_reader :order, :step

      def initialize(order, step)
        @order = order
        @step = step
      end

      def call
        if order.items_count.zero? && step != :complete
          return broadcast(:empty_cart)
        end
        allow? ? broadcast(:allow) : broadcast(:not_allow)
      end

      private

      def allow?
        step_class.allow?(order)
      end

      def step_class
        "Corzinus::Checkout::#{step.to_s.camelize}AccessService".constantize
      end
    end
  end
end
