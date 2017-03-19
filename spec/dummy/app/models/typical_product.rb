class TypicalProduct < ApplicationRecord
  has_one :inventory, as: :productable, class_name: 'Corzinus::Inventory'
end
