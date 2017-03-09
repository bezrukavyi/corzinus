module Corzinus
  module Relatable
    module Address
      extend ActiveSupport::Concern

      module ClassMethods
        def has_addresses
          Corzinus::Address::TYPES.each { |type| has_address type }
        end

        def has_address(address_type)
          has_one :"#{address_type}", -> { where(address_type: address_type) },
                  class_name: Corzinus::Address, as: :addressable,
                  dependent: :destroy
          accepts_nested_attributes_for address_type
        end
      end

      def addresses
        Corzinus::Address::TYPES.map { |type| send(type.to_s) }
      end

      def any_address?
        addresses.any?(&:present?)
      end
    end
  end
end
