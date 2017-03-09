module Corzinus
  module Relatable
    module Order
      extend ActiveSupport::Concern

      module ClassMethods
        def has_orders
          has_many :orders, class_name: Corzinus::Order,
                            foreign_key: :person_id,
                            dependent: :nullify
        end
      end

      def order_in_processing
        @order_in_processing ||= orders.processing.last || orders.create
      end

      def complete_order
        @complete_order ||= orders.in_progress.last
      end

      def purchase(productable)
        orders.delivered
              .joins(:order_items)
              .where('order_items.productable_id = ?', productable.id)
      end

      def bought_product?(productable)
        purchase(productable).any?
      end
    end
  end
end
