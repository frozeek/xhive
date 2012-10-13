$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "xhive/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "xhive"
  s.version     = Xhive::VERSION
  s.authors     = ["frozeek"]
  s.email       = ["marcelo@frozeek.com"]
  s.homepage    = "http://github.com/frozeek/xhive"
  s.summary     = "Rails AJAX CMS"
  s.description = "Rails AJAX CMS"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2.8"
  s.add_dependency "jquery-rails"
  s.add_dependency "friendly_id", "~> 4.0.1"
  s.add_dependency "cells", '3.8.5'
  s.add_dependency "slim"
  s.add_dependency "liquid"
  s.add_dependency "coffee-rails", '~> 3.2.1'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "shoulda"
  s.add_development_dependency "debugger"
end
