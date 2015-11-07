class RackApp
  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
  end

  def response
    p %x(grunt)
    @user = User.new
    case
    when @request.path == '/greeting' && @request.post?
      Rack::Response.new do |resp|
        @user.greeting = @request.params['phrase']
        resp.redirect('/')
      end
    when @request.path == '/greeting' && @request.get?
      Rack::Response.new(render_html("public/templates#{@request.path}"))
    else
      Rack::Response.new(render_html)
    end
  end

  def greeting
    @user.greeting
  end

  def render_html(template = 'public/views/index')
    File.read("#{template}.html")
  end

  def render_asset(asset)
    File.read(asset)
  end

  def log(env)
    $env = env.each do |k, v|
      p "#{k} => #{v}"
    end
  end
end
