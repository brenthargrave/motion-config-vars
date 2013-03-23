# coding: utf-8
require File.expand_path('../lib/motion-config-vars/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "motion-config-vars"
  spec.version       = ConfigVars::VERSION
  spec.authors       = ["Brent Hargrave"]
  spec.email         = ["brent@brent.is"]
  spec.description   = %q{Heroku-style config vars for RubyMotion}
  spec.summary       = %q{Heroku-style config vars for RubyMotion}
  spec.homepage      = "https://github.com/jamescallmebrent/motion-config-vars"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency('motion-yaml', '>= 1.0')
  spec.add_dependency('rake-hooks', '~> 1.2.3')
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
