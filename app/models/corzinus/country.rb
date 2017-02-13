module Corzinus
  class Country < ApplicationRecord
    has_many :deliveries, class_name: 'Corzinus::Delivery'
  end
end
