module Corzinus
  class Inventory < ApplicationRecord
    belongs_to :productable, polymorphic: true

    has_many :sales, -> { order(created_at: :desc) },
             class_name: 'Corzinus::InventorySale',
             dependent: :destroy

    has_many :supplies, through: :sales

    validates :count, numericality: { greater_than_or_equal_to: 0 }

    scope :with_components, -> { includes(sales: :supply) }

    def add_sale
      finish_prev_sale
      increase_by_supply!
      sales.create(start_stock: count)
    end

    def need_supply?
      count < sum_demands
    end

    def demands
      limit = InventorySupply::TIME_RESERVE + 1
      @demands ||= sales.first(limit).pluck(:demand).compact
    end

    def sum_demands
      demands.inject(0, :+)
    end

    def average_demand
      sum_demands / demands.size
    end

    def arrived_supply
      date = Time.zone.now
      date_range = (date.beginning_of_day..date.end_of_day)
      @arrived_supply ||= supplies.where(arrived_at: date_range).first
    end

    private

    def finish_prev_sale
      last_sale = sales.first
      return if last_sale.blank?
      last_sale.finish!(count)
    end

    def increase_by_supply!
      return if arrived_supply.blank?
      increment! :count, arrived_supply.size
    end
  end
end
