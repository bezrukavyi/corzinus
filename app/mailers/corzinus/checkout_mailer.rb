module Corzinus
  class CheckoutMailer < ApplicationMailer
    add_template_helper(Corzinus::ApplicationHelper)

    def complete(person, order)
      @person = person
      @order = order
      mail to: @person.email, subject: "Complete Order ##{@order.id}"
    end
  end
end
