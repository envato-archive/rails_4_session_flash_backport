require "bundler/gem_tasks"

namespace :test do
  task :rails3 do
    system "export ACTIONPACK_VERSION=3.2.9 && bundle update"
    system "export ACTIONPACK_VERSION=3.2.9 && bundle exec rspec spec/rails3_spec.rb"
  end
end
