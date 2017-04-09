module Corzinus
  class CreditCardForm < Rectify::Form
    include Corzinus::BaseValidators

    STRING_ATTRS = [:name, :number, :cvv, :month_year].freeze

    STRING_ATTRS.each do |name|
      attribute name, String
      validates name, presence: true
    end

    validates :name, length: { maximum: 50 }, human_name: :few
    validates :number, credit_card_number: true
    validates :number, :cvv, numericality: { only_integer: true }
    validates :cvv, length: { in: 3..4 }
    validates :month_year, credit_card_month_year: true
  end
end
