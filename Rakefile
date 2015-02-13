#!/usr/bin/env rake
require 'rubygems'
require 'bundler/setup'
require 'bundler/gem_tasks'

task :spec do
  rails_version = ENV["BUNDLE_GEMFILE"][/rails\-(\d)/, 1]
  system "bundle", "exec", "rspec", "--color", "spec/rails#{rails_version}" or fail
end

task :default => :spec
