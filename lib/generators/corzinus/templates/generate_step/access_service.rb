module Corzinus
  module Checkout
    class <%= @step_class %>AccessService < AccessService
      def valid?
        true
      end
    end
  end
end
