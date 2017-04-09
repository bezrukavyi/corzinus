module Corzinus
  module BaseValidators
    class AddressValidator < ActiveModel::EachValidator
      def validate_each(object, attribute, value)
        options.keys.each do |inspection|
          next if value =~ send(inspection)
          object.errors.add(attribute, I18n.t("corzinus.validators.address.#{inspection}"))
        end
      end

      private

      def name
        symbols = /[[:alpha:]\d]/
        /\A#{symbols}+(?>.*[-,\s])*#{symbols}*\z/
      end

      def zip
        /\A\d+(?>.*[-])*\d+\z/
      end
    end
  end
end
