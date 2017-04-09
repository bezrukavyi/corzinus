module Corzinus
  module Checkout
    class AddressStep < Rectify::Command
      include Corzinus::AddressableAttrubutes

      attr_reader :addressable, :addresses, :params

      def initialize(options)
        @addressable = options[:order]
        @params = options[:params]
        @addresses = addresses_by_params(params[:order],
                                         params[:use_base_address])
      end

      def call
        if attributes_valid? && update_addressable
          broadcast(:valid)
        else
          broadcast :invalid, expose_addresses
        end
      end

      private

      def attributes_valid?
        addresses.map(&:valid?).all?
      end

      def update_addressable
        attributes = addresses.map do |address|
          ["#{address[:address_type]}_attributes", address.to_h.except(:id)]
        end
        if addressable.respond_to?(:use_base_address)
          attributes << [:use_base_address, params[:use_base_address]]
        end
        addressable.update_attributes(attributes.to_h)
      end

      def expose_addresses
        addresses.map { |address| [address.address_type, address] }.to_h
      end
    end
  end
end
