require 'yaml'

FIXTURES_DIR = File.join(File.dirname(__FILE__), "..", "fixtures")

def load_fixture(name)
  YAML.load_file("#{FIXTURES_DIR}/#{name}.yml")
end
