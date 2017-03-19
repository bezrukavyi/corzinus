module Corzinus
  class InventoriesController < ApplicationController
    layout 'application'

    def show
      @inventory = Inventory.find(params[:id])
    end
  end
end
