require 'rubygems'
require 'bundler/setup'
require 'bundler/gem_tasks'

desc "Run specs for loaded version of rails"
task :spec do
  rails_version = Gem.loaded_specs["rails"].version.to_s

  spec_dir =
    case rails_version
    when /\A2\./
      "spec/rails2"
    when /\A3\.0\./
      "spec/rails3-0"
    when /\A3\./
      "spec/rails3-1"
    when /\A4\./
      "spec/rails4"
    else
      fail "rails_4_session_flash_backport doesnt yet do anything on Rails #{rails_version}"
    end

  system "bundle", "exec", "rspec", "--color", spec_dir or fail
end

task :default => :spec
