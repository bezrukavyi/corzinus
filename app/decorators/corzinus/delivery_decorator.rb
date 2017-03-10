module Corzinus
  class DeliveryDecorator < Drape::Decorator
    delegate_all

    def duration
      to_text = I18n.t('corzinus.checkouts.delivery.from')
      from_text = I18n.t('corzinus.checkouts.delivery.to')
      days_text = I18n.t('corzinus.checkouts.delivery.days')
      [to_text, min_days, from_text, max_days, days_text].join(' ')
    end

    def order_subtotal(order)
      order.calc_total_cost(:coupon) + price
    end
  end
end
