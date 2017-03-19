module Corzinus
  class InventorySupply < ApplicationRecord
    TIME_RESERVE = 6
    DELIVERY_DAYS = 4

    belongs_to :sale, class_name: 'Corzinus::InventorySale',
                      foreign_key: 'inventory_sale_id'

    before_create :set_arrived_at

    private

    def set_arrived_at
      self.arrived_at = sale.created_at + DELIVERY_DAYS.days
    end
  end
end
