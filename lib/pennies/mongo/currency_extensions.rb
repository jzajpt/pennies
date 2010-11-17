# encoding: utf-8

module Pennies

  module Mongo

    module CurrencyExtensions

      extend ActiveSupport::Concern

      module ClassMethods

        # Convert value to a mongo safe data type
        def set(value)
          value.is_a?(self) ? value.code : value
        end

        # Convert value from a mongo safe data type to your custom data type
        def get(value)
          return nil if value.nil?
          value.is_a?(self) ? value : self.new(value)
        end

      end

    end

  end
end