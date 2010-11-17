# encoding: utf-8

module Pennies

  class NotImplementedError < StandardError; end

  class << self
    attr_accessor :exchange_bank
  end

  autoload :Currency, "pennies/currency"
  autoload :Money,    "pennies/money"

end

require 'pennies/exchange_bank'
require 'pennies/validators/currency_code_validator'

# Dummy exchange bank
Pennies.exchange_bank = Pennies::ExchangeBank.new

