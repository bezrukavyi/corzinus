module Corzinus
  class CreditCardDecorator < Drape::Decorator
    delegate_all

    def hidden_number
      hidden = '** ' * 3
      hidden + number.last(4)
    end
  end
end
