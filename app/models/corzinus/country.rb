module Corzinus
  class Country < ApplicationRecord
    validates :name, :code, presence: true
    has_many :deliveries, class_name: 'Corzinus::Delivery'
  end
end
