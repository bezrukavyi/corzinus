module Corzinus
  class InventorySale < ApplicationRecord
    belongs_to :inventory, class_name: 'Corzinus::Inventory'
    has_one :supply, class_name: 'Corzinus::InventorySupply'

    validates :start_stock, numericality: { greater_than_or_equal_to: 0 },
                            presence: true

    after_create :issue_supply

    def finish!(count)
      self.finish_stock = count
      self.demand = start_stock - count
      tap(&:save)
    end

    def issue_supply
      return unless inventory.need_supply?
      size = inventory.average_demand * InventorySupply::TIME_RESERVE
      create_supply(size: size)
    end

    def demand
      super_demand = super
      super_demand.blank? ? (start_stock - inventory.count) : super_demand
    end
  end
end
