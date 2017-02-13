module Corzinus
  class OrderItem < ApplicationRecord
    belongs_to :order, class_name: 'Corzinus::Order'
    belongs_to :productable, polymorphic: true
  end
end
