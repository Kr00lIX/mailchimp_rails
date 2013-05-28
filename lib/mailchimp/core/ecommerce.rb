module Mailchimp
  class Ecommerce < Base
    class << self
      # Order format (either email or email_id is required):
      #
      # {
      #   :id => "2",
      #   :campaign_id => "b1f66b337c",
      #   :email_id => "fd51605340",
      #   :email => "test@example.com"
      #   :total => 950,
      #   :order_date => "...",
      #   :shipping => 10,
      #   :tax => 50,
      #   :store_id => "fotoshkola_net",
      #   :store_name => "Fotoshkola.net",
      #   :items => [
      #     {
      #       :line_num => 1,
      #       :product_id => 23,
      #       :sku => "Course-23",
      #       :product_name => "Курс «Натюрморт. Основы»",
      #       :category_id => 1,
      #       :category_name => "Курсы",
      #       :qty => 1,
      #       :cost => 950
      #     }
      #   ]
      # }
      #
      # http://apidocs.mailchimp.com/api/1.3/ecommorderadd.func.php
      def add_order(order)
        run do
          hominid.ecommOrderAdd(order)
        end
      end

      def delete_order(store_id, order_id)
        run do
          hominid.ecommOrderDel(store_id, order_id)
        end
      end

      def orders(start = 0, limit = 1000, since = nil)
        run do
          hominid.ecommOrders(start, limit, since)
        end
      end
    end
  end
end