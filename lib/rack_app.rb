class RackApp
  def call(env)
    log(env)

    @request = Rack::Request.new(env)
    @user = User.new
    case
    when @request.path == '/greeting' && @request.post?
      Rack::Response.new do |resp|
        @user.greeting = @request.params['phrase']
        resp.redirect('/')
      end
    when @request.path == '/greeting' && @request.get?
      Rack::Response.new(slim("app/views#{@request.path}"))
    else
      Rack::Response.new(slim)
    end
  end

  def greeting
    @user.greeting
  end

  def slim(template = 'app/views/index', options = {}, &block)
    Slim::Template.new("#{template}.slim", options).render(self, &block)
  end

  def log(env)
    $env = env.each do |k, v|
      p "#{k} => #{v}"
    end
  end
end
