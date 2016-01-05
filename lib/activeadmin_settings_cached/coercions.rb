module ActiveadminSettingsCached
  class Coercions
    attr_reader :defaults, :display

    def initialize(params, defaults, display)
      @params = params
      @defaults = defaults
      @display = display

      init_methods
    end

    def cast_params
      params = @params.map do |name, value|
        [name, cast_value(name, value)]
      end

      return params unless block_given?

      params.each do |name, value|
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

      coerce :float do |value|
        Float value
      end

      coerce :integer do |value|
        Float(value).to_i
      end

      coerce :symbol do |value|
        String(value).to_sym
      end
    end

    def cast_value(name, value)
      case defaults[name]
      when TrueClass, FalseClass
        display[name] == 'boolean' ? -> { string_to_boolean(value) } : -> { value }
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
