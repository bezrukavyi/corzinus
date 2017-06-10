module Corzinus
  class InventoryAnalysis < ApplicationRecord
    validates :inventory_data, :demand_data, :price_data, :delivery_cost,
              :warehous_cost, :reserves, :delivery_days, presence: true

    def all_profits
      @all_profits ||= analysed_reserves.all_profits
    end

    def inventories_profit
      @inventories_profit ||= analysed_reserves.inventories_profit.to_h
    end

    def analysed_reserves
      @analysed_reserves ||= BestReserveValue.new(attributes)
    end
  end
end
