require 'rethinkdb'
include RethinkDB::Shortcuts

class RethinkDBConnection
  def self.open
    execute(r.db('test').table('users').limit(1)).first
  end

  def self.write(attribute, value)
    execute(r.db('test').table('users').insert({ "#{attribute}" => value }))
  end

  def self.execute(query)
    conn = r.connect(:host => "localhost", :port => 28015)
    values = query.send(:run, conn)
    conn.close
    values
  end
end