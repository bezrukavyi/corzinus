module Corzinus
  class InventorySalesController < ApplicationController
    def index
      @inventory = Inventory.find(params[:inventory_id])
      @sales = InventorySale.includes(:supply).order(created_at: :desc)
                            .where(inventory_id: params[:inventory_id])
                            .page(params[:page])
    end
  end
end
