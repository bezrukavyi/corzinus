module Corzinus
  class Address < ApplicationRecord
    enum address_type: [:billing, :shipping]

    TYPES = address_types.keys
    BASE = :billing
    DELIVERY = :shipping

    belongs_to :addressable, polymorphic: true
    belongs_to :country, class_name: 'Corzinus::Country'
  end
end
