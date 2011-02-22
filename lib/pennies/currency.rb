# encoding: utf-8

require 'pennies/mongo/currency_extensions'

module Pennies

  class Currency

    class << self

      attr_accessor :currencies

      def find(code)
        self.currencies.select { |c| c.code.to_s == code.to_s }.first
      end

    end

    include Mongo::CurrencyExtensions

    attr_accessor :code
    attr_accessor :sign
    attr_accessor :name
    attr_accessor :format

    def initialize(*args)
      assign_variables(args)
    end

    # String representation of currency.
    def to_s
      "#{@name} - #{@sign}"
    end

    # Compare two objects for same currency code.
    def ==(o)
      o.is_a?(Currency) &&
        @code.to_s == o.code.to_s
    end

    protected

    def assign_variables(ary)
      @code, @name, @sign, @format = ary
    end

  end

end

#              Code, Name,                   Symbol, Format
currencies = [[:CZK, "Czech Koruna",         "Kč",  "%n %s"],
              [:USD, "United States Dollar", "US$", "%s%n"],
              [:CAD, "Canadian Dollar",      "C$",  "%s%n"],
              [:AUD, "Australian Dollar",    "A$",  "%s%n"],
              [:PLN, "Polish złoty",         "PLN", "%n %s"],
              [:EUR, "Euro",                 "€",   "%s%n"],
              [:GBP, "Pound Sterling",       "£",   "%s%n"],
              [:JPY, "Japanese Yen",         "¥",   "%s%n"],
              [:CHF, "Swiss franc",          "CHF", "%n %s"],
              [:RUB, "Russian Ruble",        "RUB", "%n %s"]]

Pennies::Currency.currencies = currencies.map { |data| Pennies::Currency.new(*data) }
