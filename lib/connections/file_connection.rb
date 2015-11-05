require 'yaml'
module FileConnection
  FILE_PATH = 'lib/files/users.yml'
  def self.open(file = FILE_PATH)
    YAML.load_file(file)
  end

  def self.write(attribute, value, file = FILE_PATH)
    yaml = open(file)
    yaml[attribute] = value
    File.open(file, 'w') { |f| f.write yaml.to_yaml }
  end
end