class RackApp
  def call(env)
    log(env)

    Rack::Response.new("hello!\n")
  end

  def log(env)
    $env = env.each do |k, v|
      p "#{k} => #{v}"
    end
  end
end
