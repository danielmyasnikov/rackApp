class User
  def greeting
    connection.open['greeting']
  end

  def greeting=(my_greeting)
    connection.write('greeting', my_greeting)
  end

  def connection
    FileConnection
  end
end