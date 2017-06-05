module Corzinus
  class InventoryAnalysesController < ApplicationController
    def edit
      @inventory_analysis = InventoryAnalysis.last || InventoryAnalysis.new
      @form = InventoryAnalysisForm.from_model(@inventory_analysis)
    end

    def update
      @form = InventoryAnalysisForm.from_params(params)
      if @form.save
        redirect_to inventory_analysis_path
      else
        flash_render :edit, alert: t('corzinus.flash.failure.inventory_analysis_create')
      end
    end

    def create
      redirect_to :show if InventoryAnalysis.last

      @form = InventoryAnalysisForm.from_params(params)
      if @form.save
        redirect_to inventory_analysis_path
      else
        flash_render :edit, alert: t('corzinus.flash.failure.inventory_analysis_create')
      end
    end

    def show
      @inventory_analysis = InventoryAnalysis.last
      redirect_to edit_inventory_analysis_path unless @inventory_analysis
    end
  end
end
