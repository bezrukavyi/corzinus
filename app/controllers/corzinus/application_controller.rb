module Corzinus
  class ApplicationController < ActionController::Base
    include Flashable

    protect_from_forgery with: :exception

    helper_method :current_order

    def authenticate_person!
      auth_method = "authenticate_#{Corzinus.person_class.underscore}!"
      send(auth_method) if respond_to?(auth_method)
    end

    def current_person
      resource_method = "current_#{Corzinus.person_class.underscore}"
      send(resource_method) if respond_to?(resource_method)
    end

    def current_order
      @current_order ||= set_current_order
    end


    private

    def set_current_order
      order = Order.find_by(id: session[:order_id], state: 'processing')
      order ||= Order.create
      if current_person
        order = current_person.order_in_processing.merge_order!(order)
      end
      session[:order_id] = order.id
      order
    end
  end
end
