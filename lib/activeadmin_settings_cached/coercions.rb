module ActiveadminSettingsCached
  class Coercions
    SIMPLE_COERCIONS = {
      float: :to_f,
      integer: :to_i,
      symbol: :to_sym
    }
    attr_reader :defaults, :display

    def initialize(defaults, display)
      @defaults = defaults
      @display = display

      init_methods
    end

    def cast_params(params)
      coerced_params = params.map do |name, value|
        [name, cast_value(name, value)]
      end

      return coerced_params unless block_given?

      coerced_params.each do |name, value|
        yield(name, value.call)
      end
    end

    private

    def coerce(m, &block)
      define_singleton_method :"string_to_#{m.to_s}", &block
    end

    def init_methods
      coerce :boolean do |value|
        value && %w(true 1 yes y t).include?(value)
      end

      SIMPLE_COERCIONS.each do |k, v|
        coerce(k) { |value| String(value).send(v) }
      end
    end

    def cast_value(name, value)
      case defaults[name]
      when TrueClass, FalseClass
        display[name].to_s == 'boolean' ? -> { string_to_boolean(value) } : -> { value }
      when Integer
        -> { string_to_integer(value) }
      when Float
        -> { string_to_float(value) }
      when Symbol
        -> { string_to_symbol(value) }
      else
        -> { value }
      end
    end
  end
end
