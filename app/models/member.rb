class Member < ActiveRecord::Base
  include PostgresAdapter

  class << self
    def attributes
      %w(username registered)
    end

    def all
      values = read('select * from member')
      p values
      values.map do |val|
        { id: val.first, username: val[1], registered: to_bool(val[2]), }
      end
    end
  end
end