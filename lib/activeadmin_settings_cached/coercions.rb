# frozen_string_literal: true

require 'dry-types'

module ActiveadminSettingsCached
  # Coerce user input values to defined types
  #
  # @api private
  class Coercions
    attr_reader :defaults, :display

    def initialize(defaults, display)
      @defaults = defaults
      @display = display
    end

    def cast_params(params)
      coerced_params = params.to_unsafe_h.map do |name, value|
        [name, cast_value(name, value)]
      end

      return coerced_params unless block_given?

      coerced_params.each do |name, value|
        yield(name, value.call) unless value.nil?
      end
    end

    private

    def cast_value(name, value)
      case defaults[name]
      when TrueClass, FalseClass
        -> { value_or_default('bool', value, false) }
      when Integer
        -> { value_or_default('integer', value, 0) }
      when Float
        -> { value_or_default('float', value, 0.0) }
      when Hash, 'ActiveSupport::HashWithIndifferentAccess'
        nil
      when Symbol
        -> { value.to_sym }
      else
        -> { value }
      end
    end

    def value_or_default(type, value, default)
      result = Dry::Types["params.#{type}"].call(value)
      if Dry::Types[type].valid?(result)
        result
      else
        default
      end
    end
  end
end
