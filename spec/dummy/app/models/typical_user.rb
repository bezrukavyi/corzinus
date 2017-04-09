class TypicalUser < ApplicationRecord
  include Corzinus::Relatable::Address
  include Corzinus::Relatable::Order

  has_addresses
  has_orders


end
