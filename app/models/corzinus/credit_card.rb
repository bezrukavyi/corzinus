module Corzinus
  class CreditCard < ApplicationRecord
    belongs_to :person, optional: true, class_name: Corzinus.person_class.to_s
    has_many :orders, dependent: :destroy, class_name: 'Corzinus::Order'
  end
end
