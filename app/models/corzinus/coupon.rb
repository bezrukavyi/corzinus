module Corzinus
  class Coupon < ApplicationRecord
    belongs_to :order, optional: true, class_name: 'Corzinus::Order'
  end
end
