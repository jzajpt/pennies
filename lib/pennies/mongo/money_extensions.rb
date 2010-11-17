# encoding: utf-8

module Pennies

  module Mongo

    module MoneyExtensions
      
      extend ActiveSupport::Concern

      module ClassMethods

        # Convert value to a mongo safe data type
        def set(value)
          # Rails.logger.debug "CurrencyAmount#set(#{value.inspect})"
          if value.is_a?(self)
            value.to_a
          elsif value.is_a?(Numeric)
            [value * 100, nil]
          elsif value.is_a?(String)
            [value.to_i * 100, nil]
          else
            value
          end
        end

        # Convert value from a mongo safe data type to your custom data type
        def get(value)
          # Rails.logger.debug "CurrencyAmount#get(#{value.inspect})"
          return nil if value.nil?
          value.is_a?(self) ? value : self.new(value)
        end

      end

    end

  end
end