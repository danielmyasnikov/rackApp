require 'benchmark'
require 'pg'

module PostgresAdapter

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def connection
      PG.connect( dbname: 'rackapp' )
    end

    def read(sql)
      val = nil
      execute { |conn| val = conn.exec(sql).values }
      val
    end

    # expecting a hash { username: 'dan', age: 27, registered: true }
    def create(values)
      values = normalize(values.values)
      execute { |conn| conn.exec("INSERT INTO \"#{table_name}\" (#{attrs}) values (#{values});") }
    end

    def normalize(values)
      values.map do |val|
        norm(val)
      end.join(',')
    end

    def norm(val)
      val = case
      when val.kind_of?(String)
        "\'#{val}\'"
      else
        val
      end
    end

    def update(id, attr_values)
      attr_values = convert(attr_values)
      self.execute { |conn| conn.exec("UPDATE \"#{table_name}\" SET #{attr_values} WHERE id = #{id}") }
    end

    def delete(id)
      self.execute { |conn| conn.exec("DELETE FROM \"#{table_name}\" WHERE id = #{id};") }
    end

    def find(id)
      record = {}
      values = read("select * from \"#{table_name}\" where id = #{id} limit 1;").first

      if values
        attributes.unshift(:id).each_with_index { |attr, i| record[attr.to_sym] = values[i] } 
      end

      record.empty? ? nil : record
    end

    # this looks like a failure when read is performened
    def execute
      conn = connection
      Benchmark.bm { |x| x.report { yield conn } }
      conn.close
    end

    def convert(attr_values)
      attr_values = attr_values.each { |k, v| attr_values[k] = norm(v) }
      attr_values = attr_values.map  { |x| x.join('=') }
      attr_values.join(',')
    end

    def table_name
      self.to_s.downcase
    end

    def to_bool(val)
      val == 't' ? true : false
    end

    def attrs
      attributes.join(',')
    end
  end
end