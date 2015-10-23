require_relative 'db_connection'
require 'active_support/inflector'

class SQLObject

  def self.columns
    columns = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
      LIMIT
        0
    SQL

    columns.flatten.map(&:to_sym)
  end

  def self.finalize!
    self.columns.each do |col_name|
      define_method("#{col_name}=".to_sym) do |arg|
        attributes[col_name] = arg
      end

      define_method(col_name) do
        attributes[col_name]
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name || self.to_s.tableize
  end

  def self.all
    all = DBConnection.execute(<<-SQL)
    SELECT
      #{self.table_name}.*
    FROM
      #{self.table_name}
    SQL

    self.parse_all(all)
  end

  def self.parse_all(results)
    new_instances = results.map do |row_data|
      self.new(row_data)
    end

    new_instances
  end

  def self.find(id)
    result = DBConnection.execute(<<-SQL, id)
    SELECT
      #{self.table_name}.*
    FROM
      #{self.table_name}
    WHERE
      #{self.table_name}.id = ?
    LIMIT
      1
    SQL

    result.empty? ? nil : self.new(result[0])
  end

  def initialize(params = {})
    params.each do |attr_name, value|
      if !self.class.columns.include?(attr_name.to_sym)
        raise "unknown attribute '#{attr_name}'"
      end
      self.send("#{attr_name}=".to_sym, value)
    end
  end

  def attributes
    @attributes || @attributes = {}
  end

  def attribute_values
    self.class.columns.map { |col| self.send(col) }
  end

  def insert
    col_names = self.class.columns.join(", ")
    q_marks = (["?"] * attribute_values.length).join(", ")

    DBConnection.execute(<<-SQL, *attribute_values)
    INSERT INTO
      #{self.class.table_name} (#{col_names})
    VALUES
      (#{q_marks})
    SQL
    self.id = DBConnection.last_insert_row_id
  end

  def update
    col_names = self.class.columns.map { |c| "#{c} = ?" }.join(", ")
    q_marks = (["?"] * attribute_values.length).join(", ")

    DBConnection.execute(<<-SQL, *attribute_values, id)
    UPDATE
      #{self.class.table_name}
    SET
      #{col_names}
    WHERE
      id = ?
    SQL
  end

  def save
    id.nil? ? insert : update
  end
end
