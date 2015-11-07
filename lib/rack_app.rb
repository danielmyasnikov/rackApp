class RackApp
  def self.call(env)
    new(env).response.finish
  end

  def not_found
    Rack::Response.new do |resp|
      resp.header['Content-Type'] = 'text/plain'
      resp.status = 404
      resp.body = [{ 
        message: "[#{req_type}] for [#{req_path}] do not exist"
      }.to_json]
    end
  end

  def req_type
    @request.request_method
  end

  def req_path
    @request.path
  end

  def initialize(env)
    @request = Rack::Request.new(env)
  end

  def response
    p %x(grunt)

    case
    when @request.path.match(/\/api/)
      require 'json'

      case @request.path
      when /^\/api\/users\/?$/
        User.all
      when /\/api\/users\/(\d{1,}$)/
        User.find($1)
      else
        not_found
      end
    else
      Rack::Response.new(render_html)
    end
  end

  def greeting
    @user.greeting
  end

  def render_html(template = 'index')
    File.read("public/views/#{template}.html")
  end

  def log(env)
    $env = env.each do |k, v|
      p "#{k} => #{v}"
    end
  end
end
