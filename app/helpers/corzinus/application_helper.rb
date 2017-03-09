module Corzinus
  module ApplicationHelper
    def currency_price(price)
      number_to_currency price, locale: :eu
    end
  end
end
