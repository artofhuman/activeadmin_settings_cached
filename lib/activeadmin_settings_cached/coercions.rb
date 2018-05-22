# frozen_string_literal: true

module ActiveadminSettingsCached
  # Coerce user input values to defined types
  #
  # @api private
  class Coercions
    TRUE_VALUES = %w[1 on On ON t true True TRUE T y yes Yes YES Y].freeze
    FALSE_VALUES = %w[0 off Off OFF f false False FALSE F n no No NO N].freeze
    BOOLEAN_MAP = ::Hash[
      TRUE_VALUES.product([true]) + FALSE_VALUES.product([false])
    ].freeze

    attr_reader :defaults, :display

    def initialize(defaults, display)
      @defaults = defaults
      @display  = display
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

    def cast_value(name, value) # rubocop:disable Metrics/MethodLength
      case defaults[name]
      when TrueClass, FalseClass
        -> { BOOLEAN_MAP.fetch(value, false) }
      when Integer
        -> { value_or_default(0) { Integer(value) } }
      when Float
        -> { value_or_default(0.0) { Float(value) } }
      when Hash, 'ActiveSupport::HashWithIndifferentAccess'
        nil
      when Symbol
        -> { value.to_sym }
      else
        -> { value }
      end
    end

    def value_or_default(default)
      yield
    rescue ArgumentError, TypeError
      default
    end
  end
end
