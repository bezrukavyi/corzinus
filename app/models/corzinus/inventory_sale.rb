module Corzinus
  class InventorySale < ApplicationRecord
    belongs_to :inventory, class_name: 'Corzinus::Inventory'

    validates :start_stock, numericality: { greater_than_or_equal_to: 0 },
                            presence: true
  end
end
