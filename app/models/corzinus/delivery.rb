module Corzinus
  class Delivery < ApplicationRecord
    has_many :orders, class_name: 'Corzinus::Order'
    belongs_to :country, class_name: 'Corzinus::Country'
  end
end
