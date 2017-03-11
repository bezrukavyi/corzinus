module Corzinus
  module Checkout
    class AddressAccessService < AccessService
      def valid?
        order.addresses.map(&:present?).all?
      end
    end
  end
end
