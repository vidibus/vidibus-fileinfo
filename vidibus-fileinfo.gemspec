# -*- encoding: utf-8 -*-
require File.expand_path("../lib/vidibus/fileinfo/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "vidibus-fileinfo"
  s.version     = Vidibus::Fileinfo::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = "Andre Pankratz"
  s.email       = "andre@vidibus.com"
  s.homepage    = "https://github.com/vidibus/vidibus-fileinfo"
  s.summary     = "Returns information about an image or video file."
  s.description = "Gets width, height, bits and other figures."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "vidibus-fileinfo"

  s.add_dependency "actionpack", "~> 3.0.4"
  s.add_dependency "vidibus-core_extensions"
  s.add_dependency "open4"
  s.add_dependency "newbamboo-rvideo"

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec", "~> 2.0.0.beta.20"
  s.add_development_dependency "rr"
  s.add_development_dependency "relevance-rcov"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
