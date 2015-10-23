require_relative '02_searchable'
require 'active_support/inflector'

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    class_name.to_s.singularize.constantize
  end

  def table_name
    class_name == "Human" ? "humans" : class_name.tableize
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})

    class_name_value = options[:class_name] || name.to_s.capitalize
    foreign_key_value = options[:foreign_key] || "#{name.to_s.singularize}_id".to_sym
    primary_key_value = options[:primary_key] || :id

    self.foreign_key = foreign_key_value
    self.class_name = class_name_value
    self.primary_key = primary_key_value
  end

end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})

    class_name_value = options[:class_name] || name.to_s.singularize.capitalize
    foreign_key_value = options[:foreign_key] ||
      "#{self_class_name.downcase}_id".to_sym
    primary_key_value = options[:primary_key] || :id

    self.foreign_key = foreign_key_value
    self.class_name = class_name_value
    self.primary_key = primary_key_value
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    assoc_options[name] = options

    define_method(name.to_sym) do
      options.model_class.where(
        options.primary_key => self.send(options.foreign_key)).first
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.name, options)

    define_method(name.to_sym) do
      options.model_class.where(
        options.foreign_key => self.send(options.primary_key))
    end
  end

  def assoc_options
    @options ? @options : @options = {}
  end
end

class SQLObject
  extend Associatable
end
