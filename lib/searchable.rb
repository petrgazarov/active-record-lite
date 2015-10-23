require_relative 'db_connection'

module Searchable
  def where(params)
    values = params.values
    columns = params.keys.map { |k| "#{k} = ?" }.join(" AND ")

    query_data = DBConnection.execute(<<-SQL, *values)
    SELECT
      *
    FROM
      #{self.table_name}
    WHERE
      #{columns}
    SQL

    query_data.map { |q| self.new(q) }
  end
end
