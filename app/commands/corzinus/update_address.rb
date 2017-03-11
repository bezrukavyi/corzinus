module Corzinus
  class UpdateAddress < Checkout::AddressStep
    def initialize(options)
      @addressable = options[:addressable]
      @params = options[:params]
      @addresses = [address_by_params(params[:address])]
    end
  end
end
