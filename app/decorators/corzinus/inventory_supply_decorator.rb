module Corzinus
  class InventorySupplyDecorator < Drape::Decorator
    delegate_all

    def created_strftime
      created_at.strftime('%B, %d, %Y')
    end

    def arrived_strftime
      arrived_at.strftime('%B, %d, %Y')
    end
  end
end
