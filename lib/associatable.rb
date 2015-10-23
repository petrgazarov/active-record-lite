require_relative 'searchable'
require_relative 'assoc_options'
require 'active_support/inflector'

module Associatable
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

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]

      select_table = source_options.table_name
      from_table = through_options.table_name

      result = DBConnection.execute(
        <<-SQL, self.owner_id)
      SELECT
        #{select_table}.*
      FROM
        #{from_table}
      JOIN
        #{select_table}
      ON
        #{from_table}.#{source_name}_id = #{select_table}.id
      WHERE
        #{from_table}.id = ?
      SQL
      source_options.model_class.parse_all(result).first
    end
  end
end
