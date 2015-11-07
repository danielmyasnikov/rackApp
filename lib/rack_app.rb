class RackApp
  attr_reader :params

  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @env = env
    @request = Rack::Request.new(env)
  end

  def error_500(ex)
    Rack::Response.new do |resp|
      resp.header['Content-Type'] = 'application/json'
      resp.status = 500
      resp.body = [{ 
        message: "[Internal Server Error] #{ex.message}"
      }.to_json]
    end
  end

  def not_found
    Rack::Response.new do |resp|
      resp.header['Content-Type'] = 'application/json'
      resp.status = 404
      resp.body = [{ 
        message: "[#{req_type}] for [#{req_path}] do not exist"
      }.to_json]
    end
  end

  def render_json(body)
    Rack::Response.new do |resp|
      resp.header['Content-Type'] = 'application/json'
      resp.body = [body.to_json]
    end
  end

  def req_type
    @request.request_method
  end

  def req_path
    @request.path
  end

  def response
    p %x(grunt) if ENV['RACK_ENV'] == 'development'

    case
    when @request.path.match(/\/api/)
      require 'json'

      case @request.path
      when /^\/api\/members\/?$/
        if req_type == 'GET'
          render_json Member.all
        else
          member = Member.create(params)
          p member
          render_json(member)
        end
      when /\/api\/members\/(\d{1,}$)/
        unless member = Member.find($1)
          not_found
        end

        case req_type
        when 'DELETE'
          member = Member.delete($1)
          p member
          render_json(member)
        when 'PUT'
          member = Member.update(params.delete('id'), params)
          p member
          render_json(member)
        else
          render_json :member => member
        end
      else
        not_found
      end
    else
      Rack::Response.new(render_html)
    end

  rescue StandardError => se
    error_500(se)
  end

  def render_html(template = 'index')
    File.read("public/views/#{template}.html")
  end

  def params
    @params ||= JSON.parse(@env['rack.input'].gets)
  end

  def log(env)
    $env = env.each do |k, v|
      p "#{k} => #{v}"
    end
  end
end
