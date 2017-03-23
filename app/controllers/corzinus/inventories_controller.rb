module Corzinus
  class InventoriesController < ApplicationController
    def index
      @inventories = Inventory.order(:created_at).with_supplies_product.page(params[:page])
    end

    def show
      @inventory = Inventory.with_components.find(params[:id])
    end
  end
end
