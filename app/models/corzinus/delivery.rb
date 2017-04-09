module Corzinus
  class Delivery < ApplicationRecord
    has_many :orders, class_name: 'Corzinus::Order'
    belongs_to :country, class_name: 'Corzinus::Country'

    validates :min_days, :max_days, :name, :price, presence: true
    validates :min_days, :max_days, numericality: { greater_than: 0 }
    validates_uniqueness_of :name, scope: :country
    validate :access_max_days

    private

    def access_max_days
      return unless errors.blank?
      return if min_days < max_days
      errors.add(:min_days, I18n.t('corzinus.validators.delivery.access_max_days'))
    end
  end
end
