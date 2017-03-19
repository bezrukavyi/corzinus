module Corzinus
  class InventoriesController < ApplicationController
    layout 'application'

    def show
      @inventory = Inventory.with_components.find(params[:id])
    end
  end
end
