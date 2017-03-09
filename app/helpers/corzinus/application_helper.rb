module Corzinus
  module ApplicationHelper
    def currency_price(price)
      number_to_currency price, locale: :eu
    end

    def alert_class(key)
      case key
      when 'notice' then 'success'
      when 'alert' then 'warning'
      else key
      end
    end
  end
end
