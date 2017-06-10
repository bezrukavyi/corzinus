module Corzinus
  module InventoryAnalysesHelper
    def profits_chart(profits)
      index = 0
      profits.map do |profit|
        index += 1
        ["Day #{index}", profit]
      end.to_h
    end
  end
end
