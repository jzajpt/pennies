# encoding: utf-8

require 'pennies/mongo/money_extensions'

module Pennies

  class Money

    include Mongo::MoneyExtensions

    include Comparable

    attr_accessor :cents
    attr_accessor :currency

    def initialize(*args)
      @cents, @currency = if args.first.is_a?(Array)
                            args.first
                          elsif args.size > 0
                            args
                          end

      unless @currency.is_a?(Currency)
        currency_obj = Pennies::Currency.find(@currency)
        currency_obj && @currency = currency_obj
      end

      @cents ||= 0
    end

    # Return an array with cents amount and currency code.
    def to_a
      code = @currency.respond_to?(:code) ? @currency.code : @currency
      [@cents, code]
    end

    # Return a cents amount.
    def to_i
      @cents / 100.0
    end

    # Returns formatted string.
    def to_s
      if @currency.is_a?(Currency) && @currency.format
        value = "%.2f" % (@cents / 100.0)
        @currency.format.gsub('%s', @currency.sign).
                         gsub('%c', @currency.code.to_s).
                         gsub('%n', value)
      else
        "%.2f #{@currency}" % (@cents / 100.0)
      end
    end

    # Converts money amount to a new currency using Pennies.exchange_bank.
    def to_currency(new_currency, options = {})
      code = new_currency.respond_to?(:code) ? new_currency.code : new_currency
      Pennies.exchange_bank.convert(self, code, options = {})
    end

    # Compare two objects for same cents amount and currency.
    def ==(o)
      o.is_a?(Money) &&
        @cents == o.cents &&
        @currency == o.currency
    end

    # Comparision operator for Comparable mixin.
    def <=>(o)
      unless @currency == o.currency
        o = o.to_currency(@currency.code)
      end
      self.cents <=> o.cents
    end

    # Multiply amount by a number.
    def *(num)
      Money.new(@cents * num, @currency)
    end

    # Add two amounts or amounts and number.
    def +(o)
      if o.respond_to?(:cents) && o.currency == @currency
        Money.new(@cents + o.cents, @currency)
      elsif o.respond_to?(:cents) && o.currency != @currency
        exchanged = o.to_currency(@currency)
        Money.new(@cents + exchanged.cents, @currency)
      elsif o.respond_to?(:to_i)
        Money.new(@cents + o.to_i, @currency)
      end
    end

  end

end