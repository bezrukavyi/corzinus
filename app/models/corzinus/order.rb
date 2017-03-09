module Corzinus
  class Order < ApplicationRecord
    include Corzinus::AddressableRelation
    include AASM

    belongs_to :person, optional: true, class_name: Corzinus.person_class.to_s
    belongs_to :delivery, optional: true, class_name: 'Corzinus::Delivery'
    belongs_to :credit_card, optional: true, class_name: 'Corzinus::CreditCard'
    has_one :coupon, dependent: :nullify, class_name: 'Corzinus::Coupon'
    has_many :order_items, dependent: :destroy, class_name: 'Corzinus::OrderItem'

    Corzinus::Address::TYPES.each { |type| has_address type }

    accepts_nested_attributes_for :order_items, allow_destroy: true
    accepts_nested_attributes_for :credit_card

    aasm column: :state, whiny_transitions: false do
      state :processing, initial: true
      state :in_progress
      state :in_transit
      state :delivered
      state :canceled

      event :confirm do
        transitions from: :processing, to: :in_progress
      end

      event :sent do
        transitions from: :in_progress, to: :in_transit
      end

      event :delivered do
        transitions from: :in_transit, to: :delivered
      end

      event :cancel do
        transitions from: :in_progress, to: :canceled
      end
    end

    def self.assm_states
      aasm.states.map(&:name)
    end

    def add_item(productable, quantity = 1)
      return if quantity.zero?
      item = order_items.find_by(productable: productable)
      if item
        item.increment :quantity, quantity
      else
        order_items.new(quantity: quantity, productable: productable)
      end
    end

    def items_count
      order_items.map(&:quantity).sum
    end

    def sub_total
      order_items.map(&:sub_total).sum
    end

    def coupon_cost
      coupon ? coupon.calc_discount(sub_total) : 0.00
    end

    def delivery_cost
      delivery ? delivery.price : 0.00
    end

    def calc_total_cost(*additions)
      sub_total + additions.map { |addition| send("#{addition}_cost") }.sum
    end
  end
end
