require 'pg'
module PostgresConnection
  def self.connection
    PG.connect( dbname: 'rackapp' )
  end

  def self.open
    val = nil
    execute do |conn|
      val = conn.exec('select greeting from users').values
    end
    { 'greeting' => val.last.respond_to?(:first) ? val.last.first : nil }
  end

  def self.write(attributes, value)
    execute do |conn|
      conn.exec("insert into users values ('#{value}')")
    end
  end

  def self.execute
    conn = connection
    yield conn
    conn.close
  end
end