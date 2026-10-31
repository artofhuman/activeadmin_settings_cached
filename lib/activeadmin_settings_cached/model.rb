# frozen_string_literal: true

module ActiveadminSettingsCached
  class Model
    include ::ActiveModel::Model

    NUMERIC_TYPES = %i[integer float big_decimal].freeze

    attr_reader :attributes

    def initialize(args = {})
      @attributes = {}
      args[:model_name] = args[:model_name].constantize if args[:model_name].is_a? String
      args[:display] = default_attributes[:display].merge!(args[:display]) if args[:display]
      assign_attributes(merge_attributes(args))
    end

    # Editable fields grouped by rails-settings-cached scope
    def fields_by_scope
      fields.group_by { |field| field[:scope] }
    end

    def fields
      settings_model.editable_keys.map { |key| settings_model.get_field(key) }.select do |field|
        scopes.nil? || scopes.include?(field[:scope])
      end
    end

    def keys
      fields.map { |field| field[:key] }
    end

    def field_options(key)
      field = settings_model.get_field(key)
      options = field[:options] || {}
      input_html = { value: form_value(key), placeholder: format_value(field[:type], default(field)) }

      input_opts = if options[:option_values]
                     { as: :select, collection: options[:option_values], selected: value(key), include_blank: false }
                   else
                     case field[:type]
                     when :boolean
                       # Formtastic nests the checkbox into its label, so blank it
                       { as: :boolean, label: '', input_html: { checked: value(key) },
                         checked_value: 'true', unchecked_value: 'false' }
                     when :array, :hash
                       { as: :text, input_html: input_html.merge(rows: 5) }
                     when *NUMERIC_TYPES
                       { as: :number, input_html: input_html }
                     else
                       { as: :string, input_html: input_html }
                     end
                   end

      input_opts[:hint] = options[:help_text] if options[:help_text]
      input_opts[:as] = display[key] if display[key]

      { label: false }.merge(input_opts)
    end

    def value(key)
      settings_model.public_send(key)
    end

    # Value as rendered in the form, used to detect changes on save
    def form_value(key)
      format_value(settings_model.get_field(key)[:type], value(key))
    end

    def changed?(key, input)
      normalize(input) != normalize(form_value(key))
    end

    def save(key, value)
      settings_model.public_send("#{key}=", value)
    end

    def display
      attributes[:display]
    end

    def persisted?
      false
    end

    alias_method :to_hash, :attributes

    private

    def scopes
      Array(attributes[:scope]).map(&:to_sym).presence
    end

    def default(field)
      field[:default].is_a?(Proc) ? field[:default].call : field[:default]
    end

    def format_value(type, value)
      case type
      when :array
        Array(value).join("\n")
      when :hash
        value.blank? ? '' : value.to_hash.deep_stringify_keys.to_yaml.sub(/\A---\n/, '')
      else
        value.to_s
      end
    end

    def normalize(value)
      value.to_s.gsub("\r\n", "\n").strip
    end

    def assign_attributes(args = {})
      @attributes.merge!(args)
    end

    def default_attributes
      {
        scope: nil,
        model_name: ::ActiveadminSettingsCached.config.model_name,
        display: ::ActiveadminSettingsCached.config.display
      }
    end

    def merge_attributes(args)
      default_attributes.each_with_object({}) do |(k, v), h|
        h[k] = args[k] || v
      end
    end

    def settings_model
      attributes[:model_name]
    end
  end
end
