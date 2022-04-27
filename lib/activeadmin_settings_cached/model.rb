# frozen_string_literal: true

module ActiveadminSettingsCached
  class Model
    include ::ActiveModel::Model

    attr_reader :attributes

    def initialize(args = {})
      @attributes = {}
      args[:model_name] = args[:model_name].constantize if args[:model_name].is_a? String
      args[:display] = default_attributes[:display].merge!(args[:display]) if args[:display]
      assign_attributes(merge_attributes(args))
    end

    def field_options(field_name, value)
      field = settings_model.get_field(field_name)
      default_value = field[:default]

      input_opts = if default_value.is_a?(Array)
                     {
                       collection: default_value,  #TODO: allow multiply for colleactions
                       selected: value,
                     }
                   elsif (field_name.include?("time") || field_name.include?("hour"))
                   {
                       as: :time_picker,
                       input_html: { value: value, placeholder: default_value },
                   }
                   elsif (default_value.is_a?(TrueClass) || default_value.is_a?(FalseClass))
                     {
                       as: :boolean,
                       input_html: { checked: value }, label: '', checked_value: 'true', unchecked_value: 'false'
                     }


                   #elsif (default_value.is_a?(TrueClass) || default_value.is_a?(FalseClass)) &&
                   #      display[settings_name].to_s == 'boolean'
                   #  {
                   #    input_html: { checked: value }, label: '', checked_value: 'true', unchecked_value: 'false'
                   #  }
                   else
                     {
                       input_html: { value: value, placeholder: default_value },
                     }
                   end

      { as: display[field_name], label: false }
        .merge!(input_opts)
    end

    def settings
      settings_values = load_settings_values
      return unless settings_values

      ::ActiveSupport::OrderedHash[settings_values.to_a.sort { |a, b| a.first <=> b.first }]
    end

    def display
      attributes[:display]
    end

    def save(field_name, value)
      settings_model.public_send("#{field_name}=", value)
    end

    def persisted?
      false
    end

    alias_method :to_hash, :attributes

    private

    def load_settings_values
      settings_model.keys.each_with_object({}) do |key, acc|
        acc[key] = settings_model.public_send(key)
      end
    end

    def assign_attributes(args = {})
      @attributes.merge!(args)
    end

    def default_attributes
      {
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
