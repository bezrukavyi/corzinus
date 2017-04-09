module Corzinus
  class AddressDecorator < Drape::Decorator
    delegate_all

    def full_name
      [first_name, last_name].join(' ').titleize
    end

    def city_zip
      [city, zip].join(' ')
    end
  end
end
