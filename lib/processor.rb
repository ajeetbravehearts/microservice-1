require_relative 'entities'
require_relative 'order/builder'
require_relative 'payment_methods/paymill'

module Processor
  class << self
    def process(json)
      order = Order::Builder.build(json)
      process_transaction(order)
      order
    end

    private

    def process_transaction(order)
      case ENV['JSM_PAYMENT_METHOD']
      when 'Paymill'
        PaymentMethods::Paymill.process(order)
        order
      else
        fail PaymentMethodNotSet
      end
    end
  end
end

class PaymentMethodNotSet < StandardError; end