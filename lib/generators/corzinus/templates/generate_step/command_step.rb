module Corzinus
  module Checkout
    class <%= @step_class %>Step < Rectify::Command
      attr_reader :order, :params, :person

      def initialize(options)
        @order = options[:order]
        @params = options[:params]
        @person = options[:person]
      end

      def call
        if form_valid? && update_order
          broadcast :valid
        else
          broadcast :invalid
        end
      end

      private

      def form_valid?
        true
      end

      def update_order
        true
      end
    end
  end
end
