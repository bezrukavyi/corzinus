module Corzinus
  module Checkout
    class AccessService
      attr_reader :order

      class << self
        def allow?(*args)
          new(*args).allow?
        end

        def valid?(*args)
          new(*args).valid?
        end
      end

      def initialize(order)
        @order = order
      end

      def allow?
        step_dependencies.each do |step|
          step_class = "Corzinus::Checkout::#{step.to_s.camelize}AccessService".constantize
          return false unless step_class.valid?(order)
        end
        true
      end

      def valid?
        true
      end

      def step_dependencies
        steps = Corzinus.checkout_steps
        steps[0...steps.index(current_step)]
      end

      private

      def current_step
        self.class.name.demodulize.gsub('AccessService', '').underscore.to_sym
      end
    end
  end
end
