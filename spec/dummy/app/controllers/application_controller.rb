class ApplicationController < ActionController::Base
  include Corzinus::Controllable
  helper Corzinus::Engine.helpers

  protect_from_forgery with: :exception
end
