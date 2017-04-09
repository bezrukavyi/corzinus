module Corzinus
  module Checkout
    class ConfirmStep < Rectify::Command
      attr_reader :order, :person, :confirm

      def initialize(options)
        @order = options[:order]
        @person = options[:person]
        @confirm = options[:params][:confirm] if options[:params]
      end

      def call
        return broadcast(:invalid) if confirm.blank? || person.blank?
        transaction do
          order.confirm!
          send_mail
        end
        broadcast :valid
      end

      private

      def send_mail
        CheckoutMailer.complete(person, order).deliver
      end
    end
  end
end
