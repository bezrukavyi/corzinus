module Corzinus
  class Inventory < ApplicationRecord
    belongs_to :productable, polymorphic: true
    has_many :sales, dependent: :destroy, class_name: 'Corzinus::InventorySale'

    validates :count, numericality: { greater_than_or_equal_to: 0 }
  end
end
