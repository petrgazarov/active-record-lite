class AttrAccessorObject
  def self.my_attr_accessor(*names)

    names.each do |name|
      define_method(name) do
        self.instance_variable_get("@#{name}")
      end
    end

    names.each do |name|
      define_method("#{name}=".to_sym) do |arg|
        self.instance_variable_set("@#{name}", arg)
      end
    end
  end
end