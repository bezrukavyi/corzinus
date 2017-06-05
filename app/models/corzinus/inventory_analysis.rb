module Corzinus
  class InventoryAnalysis < ApplicationRecord
    validates :inventory_data, :demand_data, :price_data, :delivery_cost,
              :warehous_cost, :reserves, :delivery_days, presence: true


    def analysed_reserves
      @analysed_reserves ||= BestReserveValue.new(attributes).all_profits
    end
  end
end
