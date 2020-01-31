$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require 'simplecov'
SimpleCov.start

require "rubygems"
require "rspec"
require "vidibus-fileinfo"

require "support/stubs"
require "support/files"
require "support/fixture"

RSpec.configure do |config|
end
