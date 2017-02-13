module Corzinus
  class Order < ApplicationRecord
    belongs_to :person, optional: true, class_name: Corzinus.person_class.to_s
    belongs_to :delivery, optional: true, class_name: 'Corzinus::Delivery'
    belongs_to :credit_card, optional: true, class_name: 'Corzinus::CreditCard'
    has_one :coupon, dependent: :nullify, class_name: 'Corzinus::Coupon'
    has_many :order_items, dependent: :destroy,
                           class_name: 'Corzinus::OrderItem'

    accepts_nested_attributes_for :order_items, allow_destroy: true
    accepts_nested_attributes_for :credit_card
  end
end
