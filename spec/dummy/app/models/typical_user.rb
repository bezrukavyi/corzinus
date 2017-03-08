class TypicalUser < ApplicationRecord
  include Corzinus::AddressableRelation

  Corzinus::Address::TYPES.each { |type| has_address type }
end
