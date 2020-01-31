# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

require "vidibus/fileinfo/version"

Gem::Specification.new do |s|
  s.name        = "vidibus-fileinfo"
  s.version     = Vidibus::Fileinfo::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = "Andre Pankratz"
  s.email       = "andre@vidibus.com"
  s.homepage    = "https://github.com/vidibus/vidibus-fileinfo"
  s.summary     = "Returns information about an image, video or audio file."
  s.description = "Returns information like the width, height and bits about an image, video or audio file."

  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency "mime-types"
  s.add_dependency "posix-spawn"
  s.add_dependency "vidibus-core_extensions"

  s.add_development_dependency "bundler"
  s.add_development_dependency "rspec", "> 2.99.0"
  s.add_development_dependency "rake"
  s.add_development_dependency "rdoc"
  s.add_development_dependency 'simplecov'

  s.files = Dir.glob("{lib,app,config}/**/*") + %w[LICENSE README.md Rakefile]
  s.require_path = "lib"
end
