require_relative 'assoc_options'

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
