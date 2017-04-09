module Corzinus
  class ApplicationController < ::ApplicationController
    include Corzinus::Controllable
    include Flashable

    protect_from_forgery with: :exception
  end
end
