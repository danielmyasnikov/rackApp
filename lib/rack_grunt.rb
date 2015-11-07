class RackGrunt
  def self.call(env)
    %x(pwd)
    new(env)
  end

  def initialize(env)
    @env = env
  end
end