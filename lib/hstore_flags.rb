require 'hstore_flags/version'

module HStoreFlags
  extend ActiveSupport::Concern
  TRUE_VALUES = [true, 1, '1', 't', 'T', 'true', 'TRUE']
  STORED_TRUE_VALUE = 'true'

  private

  def set_hstore_flag_field(field, flag, value)
    old_val = send(flag)
    new_val = TRUE_VALUES.include?(value)
    return if old_val == new_val

    if respond_to?(:changed_attributes)
      @changed_attributes = changed_attributes.merge(flag.to_s => old_val)
    end

    fields = self[field] || {}

    if new_val
      self[field] = fields.merge(flag.to_s => STORED_TRUE_VALUE)
    else
      fields.delete(flag.to_s)
      self[field] = fields
    end
    new_val
  end

  module ClassMethods
    def hstore_flags(*args)
      opts  = args.extract_options!
      field = opts[:field] || "flags"
      table_field = "#{self.table_name}." + field

      class_exec do
        const_set("AVAILABLE_#{field.upcase}", args)
      end

      args.each do |flag|
        define_method("#{flag}")      {(self[field] || {})[flag.to_s] == STORED_TRUE_VALUE}
        define_method("#{flag}?")     {(self[field] || {})[flag.to_s] == STORED_TRUE_VALUE}
        define_method("not_#{flag}")  {(self[field] || {})[flag.to_s] != STORED_TRUE_VALUE}
        define_method("not_#{flag}?") {(self[field] || {})[flag.to_s] != STORED_TRUE_VALUE}
        define_method("#{flag}=")     {|val| set_hstore_flag_field(field, flag, val)}

        unless opts[:scopes] == false
          scope "#{flag}", -> { where("defined(#{table_field}, '#{flag}') IS TRUE") }
          scope "not_#{flag}", -> { where("defined(#{table_field}, '#{flag}') IS NOT TRUE") }

          class_eval <<-EVAL
            def self.#{flag}_condition
              "(defined(#{table_field}, '#{flag}') IS TRUE)"
            end

            def self.not_#{flag}_condition
              "(defined(#{table_field}, '#{flag}') IS NOT TRUE)"
            end
          EVAL
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, HStoreFlags)
