require_relative 'assoc_options'

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
