# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_4_session_flash_backport/version'

Gem::Specification.new do |gem|
  gem.name          = "rails_4_session_flash_backport"
  gem.version       = Rails4SessionFlashBackport::VERSION
  gem.authors       = ["Lucas Parry", "Samuel Cochran", "Pete Johns"]
  gem.email         = ["lparry@gmail.com", "sj26@sj26.com", "paj+rubygems@johnsy.com"]
  gem.description   = %q{Store flash in the session in Rails 4 style on Rails 2/3/4}
  gem.summary       = %q{Backport of the way Rails 4 stores flash messages in the session to Rails 2/3/4, so you can safely take a session betweens Rails versions without things exploding.}
  gem.homepage      = "https://github.com/envato/rails_4_session_flash_backport"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'rails', '>= 2.0', '< 5'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'pry'
end
