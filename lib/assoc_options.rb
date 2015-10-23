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
