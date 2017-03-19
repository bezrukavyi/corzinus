module Corzinus
  module InventoriesHelper
    def sale_chart(inventory, type)
      inventory.sales.map do |sale|
        [sale.created_at, sale.decorate.send(type)]
      end.to_h
    end
  end
end
