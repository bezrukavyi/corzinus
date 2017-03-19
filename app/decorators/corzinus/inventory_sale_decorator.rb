module Corzinus
  class InventorySaleDecorator < Drape::Decorator
    delegate_all

    def created_strftime
      created_at.strftime('%B, %d, %Y')
    end

    def supply_size
      return 0 if supply.blank?
      supply.size
    end

    def finish_stock
      super.blank? ? '-' : super
    end
  end
end
