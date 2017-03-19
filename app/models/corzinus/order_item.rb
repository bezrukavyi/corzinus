module Corzinus
  class OrderItem < ApplicationRecord
    belongs_to :order, class_name: 'Corzinus::Order'
    belongs_to :productable, polymorphic: true

    before_validation :destroy_if_empty

    validates :quantity, presence: true,
                         numericality: { greater_than_or_equal_to: 0,
                                         less_than_or_equal_to: 99 }

    def sub_total
      @sub_total ||= quantity * productable.price
    end

    def decrease_stock!
      productable.inventory.decrement!(:count, quantity)
    end

    private

    def destroy_if_empty
      destroy if persisted? && quantity.zero?
    end
  end
end
