module Corzinus
  class CheckoutsController < ApplicationController
    include Wicked::Wizard
    include AddressableAttrubutes
    include Rectify::ControllerHelpers

    steps :address, :delivery, :payment, :confirm, :complete

    before_action :authenticate_person!
    before_action :set_step_components

    def show
      Checkout::AccessStep.call(current_order, step) do
        on(:allow) { render_wizard }
        on(:not_allow) do
          redirect_to checkout_path(previous_step),
                      alert: t('corzinus.flash.failure.step')
        end
        on(:empty_cart) do
          redirect_to books_path, alert: t('corzinus.flash.failure.empty_cart')
        end
      end
    end

    def update
      options = { order: current_order, params: params, user: current_person }
      "Corzinus::Checkout::Step#{step.capitalize}".constantize.call(options) do
        on(:valid) { render_wizard current_order }
        on(:invalid) do |step_results|
          expose step_results if step_results
          render_wizard
        end
      end
    end

    private

    def set_step_components
      @steps = steps
      send("#{step}_components") if respond_to?("#{step}_components", :private)
    end

    def address_components
      object = current_order.any_address? ? current_order : current_person
      addresses_by_model(object)
      set_countries
    end

    def payment_components
      @payment_form = CreditCardForm.from_model(current_order.credit_card)
    end
  end
end
