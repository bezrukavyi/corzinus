module Corzinus
  module Support
    module Inventory
      def generate_sales_with_demands(inventory)
        start_stock = 100
        demands = Array.new(5) { rand(0..10) }
        demands.each_with_index do |demand, index|
          date = Time.zone.now - index.days
          finish_stock = start_stock - demand
          options = { start_stock: start_stock, finish_stock: finish_stock,
                      demand: demand, created_at: date }
          inventory.sales.create(options)
          start_stock -= demand
        end
        inventory.sales
      end
    end
  end
end
