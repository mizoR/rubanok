# frozen_string_literal: true

module Rubanok
  class Rule # :nodoc:
    UNDEFINED = :__undef__

    attr_reader :fields, :activate_on, :activate_always, :ignore_empty_values

    def initialize(fields, activate_on: fields, activate_always: false, ignore_empty_values: Rubanok.ignore_empty_values)
      @fields = fields.freeze
      @activate_on = Array(activate_on).freeze
      @activate_always = activate_always
      @ignore_empty_values = ignore_empty_values
    end

    def project(params)
      fields.each_with_object({}) do |field, acc|
        val = fetch_value params, field
        next acc if val == UNDEFINED

        acc[field] = val
        acc
      end
    end

    def applicable?(params)
      return true if activate_always == true

      activate_on.all? { |field| params.key?(field) && !empty?(params[field]) }
    end

    def to_method_name
      @method_name ||= build_method_name
    end

    private

    def build_method_name
      "__#{fields.join("_")}__"
    end

    def fetch_value(params, field)
      return UNDEFINED if !params.key?(field) || empty?(params[field])

      params[field]
    end

    using(Module.new do
      refine NilClass do
        def empty?
          true
        end
      end

      refine Object do
        def empty?
          false
        end
      end
    end)

    def empty?(val)
      return false unless ignore_empty_values

      val.empty?
    end
  end
end
