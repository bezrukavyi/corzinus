module Corzinus
  class InventoryProfitValue
    attr_reader :delivery_cost, :warehous_cost, :delivery_day, :reserves,
                :deliveries_data, :satisfied_demand, :deficit

    def initialize(options)
      @delivery_cost = options[:delivery_cost]
      @warehous_cost = options[:warehous_cost]
      @price = options[:price]
      @original_price = options[:original_price]

      @delivery_day = options[:delivery_day]
      @demand_data = options[:demand_data]
      @reserve_day = options[:reserve_day]

      @data_count = @demand_data.count

      @reserves = Array.new(@data_count, 0)
      @deliveries_data = Array.new(@data_count, 0)
      @satisfied_demand = Array.new(@data_count, 0)
      @deficit = Array.new(@data_count, 0)

      @reserves[0] = options[:start_reserve]
      @satisfied_demand[0] = calc_satisfied_demand(0)
      @deficit[0] = calc_deficit(0)

      imitate!
    end

    def profit
      income - expenses
    end

    def imitate!
      (1...@data_count).each do |index|
        @reserves[index] = calc_reserve(index).round
        @satisfied_demand[index] = calc_satisfied_demand(index).round
        @deficit[index] = calc_deficit(index).round
        @deliveries_data[index] = calc_deliveries_data(index).round if index >= delivery_day
      end
    end

    def income
      @satisfied_demand.sum * @price
    end

    def expenses
      (@deficit.sum * @price) + ( @deliveries_data.sum * @original_price) + @warehous_cost
    end

    private

    def calc_satisfied_demand(index)
      [@reserves[index], @demand_data[index]].min
    end

    def calc_reserve(index)
      index -= 1
      @reserves[index] - @satisfied_demand[index] + nearest_delivery(index)
    end

    def calc_deficit(index)
      @demand_data[index] - @satisfied_demand[index]
    end

    def calc_deliveries_data(index)
      last_demands = @demand_data[(index - delivery_day)...index]
      inventory = average(last_demands) * @reserve_day
      return inventory if @reserves[index] + nearest_delivery(index) < inventory
      0
    end

    def nearest_delivery(index)
      return 0 if index < delivery_day
      @deliveries_data[index - delivery_day + 1]
    end

    def average(array)
      array.reduce(:+) * 1.0 / array.size
    end
  end
end
