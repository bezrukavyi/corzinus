module Corzinus
  class ApplicationController < ActionController::Base
    include Corzinus::Controllable
    include Flashable

    protect_from_forgery with: :exception
  end
end
