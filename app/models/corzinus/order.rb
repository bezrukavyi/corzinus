module Corzinus
  class Order < ApplicationRecord
    include Corzinus::Relatable::Address
    include AASM

    has_addresses
    belongs_to :person, optional: true, class_name: Corzinus.person_class.to_s
    belongs_to :delivery, optional: true, class_name: 'Corzinus::Delivery'
    belongs_to :credit_card, optional: true, class_name: 'Corzinus::CreditCard'
    has_one :coupon, dependent: :nullify, class_name: 'Corzinus::Coupon'
    has_many :order_items, dependent: :destroy, class_name: 'Corzinus::OrderItem'

    accepts_nested_attributes_for :order_items, allow_destroy: true
    accepts_nested_attributes_for :credit_card

    before_save :update_total_price

    scope :with_products, -> { includes(order_items: :productable) }
    scope :with_persons, -> { where.not(person_id: nil) }

    aasm column: :state, whiny_transitions: false do
      state :in_progress, initial: true
      state :processing
      state :in_transit
      state :delivered
      state :canceled

      event :confirm do
        transitions from: :in_progress, to: :processing
      end

      event :sent do
        transitions from: :processing, to: :in_transit
      end

      event :delivered do
        transitions from: :in_transit, to: :delivered
      end

      event :cancel do
        transitions from: :processing, to: :canceled
      end
    end

    def self.assm_states
      aasm.states.map(&:name)
    end

    def self.not_empty
      joins(:order_items)
        .group('corzinus_orders.id')
        .having('COUNT(corzinus_order_items) != 0')
    end

    def access_deliveries
      address = send(Address::DELIVERY)
      return unless address
      @access_deliveries ||= Delivery.where(country: address.country)
    end

    def add_item!(productable, quantity = 1)
      return if quantity.zero?
      item = order_items.find_by(productable: productable)
      if item
        item.increment! :quantity, quantity
      else
        order_items.create(quantity: quantity, productable: productable)
      end
    end

    def merge_order!(order)
      return self if self == order
      order.order_items.each do |order_item|
        add_item!(order_item.productable, order_item.quantity).save
      end
      self.coupon = nil if order.coupon.present?
      order.destroy && order.coupon&.update_attributes(order: self)
      tap(&:save)
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

    private

    def update_total_price
      self.coupon = nil if items_count.zero?
      self.total_price = calc_total_cost(:coupon, :delivery)
    end
  end
end
