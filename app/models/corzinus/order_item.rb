module Corzinus
  class OrderItem < ApplicationRecord
    belongs_to :order, class_name: 'Corzinus::Order'
    belongs_to :productable, polymorphic: true

    validate :stock_validate
    validates :quantity, presence: true,
                         numericality: { greater_than_or_equal_to: 0,
                                         less_than_or_equal_to: 99 }

    private

    def stock_validate
      return if errors.present? || quantity <= productable.count
      errors.add(:quantity, I18n.t('validators.order_item.stock'))
    end
  end
end
