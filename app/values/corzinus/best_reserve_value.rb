module Corzinus
  class BestReserveValue
    attr_reader :reserves, :inventory_data, :demand_data, :price_data,
                :delivery_cost, :warehous_cost, :delivery_days,
                :original_price_data, :products

    def self.call(*args)
      new(*args).call
    end

    def initialize(attributes)
      @reserves = attributes['reserves'].map(&:to_i)

      @inventory_data = attributes['inventory_data']
      @demand_data = attributes['demand_data']
      @price_data = attributes['price_data']
      @original_price_data = attributes['original_price_data']


      @delivery_cost = attributes['delivery_cost']
      @warehous_cost = attributes['warehous_cost']

      @delivery_days = attributes['delivery_days']

      @products = demand_data.keys
    end

    def call
      all_profits.first[0]
    end

    def all_profits
      @all_profits ||= calculate_all_profits
    end

    def inventories_profit
      @inventories_profit ||= @reserves.each_with_object({}) do |reserve, reserve_profit|
        reserve_profit[reserve] = calculate_profit(reserve)
      end.sort_by { |_type, profit_objects| -global_profit(profit_objects) }
    end

    def all_expenses
      @all_expenses ||= calculate_all_expenses
    end

    private

    def calculate_all_profits
      inventories_profit.map do |type, profit_objects|
        [type.to_s, global_profit(profit_objects)]
      end.to_h
    end

    def calculate_all_expenses
      inventories_profit.map do |type, profit_objects|
        [type.to_s, profit_objects.map(&:expenses).sum]
      end.to_h
    end

    def calculate_profit(reserve)
      products.map do |type|
        options = {
          delivery_cost: delivery_cost,
          warehous_cost: warehous_cost,
          delivery_day: delivery_days,
          start_reserve: inventory_data[type].first,
          demand_data: demand_data[type],
          price: price_data[type].first,
          original_price: original_price_data[type].first,
          reserve_day: reserve
        }
        InventoryProfitValue.new(options)
      end
    end

    def global_profit(profit_objects)
      profit_objects.map(&:profit).sum - global_delivery_cost(profit_objects.sum(&:deliveries_data))
    end

    def global_delivery_cost(deliveries_data)
      deliveries_data.map { |value| value > 0 ? 1 : 0 }.sum * @delivery_cost
    end
  end
end
