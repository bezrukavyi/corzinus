module Corzinus
  class InventoryDecorator < Drape::Decorator
    include ActionView::Helpers::DateHelper

    delegate_all

    def created_strftime
      created_at.strftime('%B, %d, %Y')
    end

    def nearest_supply_relative
      return '-' if nearest_supply.blank? || nearest_supply.arrived_at <= Time.zone.now
      time_ago_in_words(nearest_supply.arrived_at)
    end
  end
end
