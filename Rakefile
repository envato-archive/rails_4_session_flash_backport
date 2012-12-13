require "bundler/gem_tasks"

namespace :test do
  task :all => [:rails2, :rails3] do
  end

  task :rails3 do
    system "export ACTIONPACK_VERSION=3.2.9 && bundle update"
    system "export ACTIONPACK_VERSION=3.2.9 && bundle exec rspec spec/rails3_spec.rb"
  end

  task :rails2 do
    system "export ACTIONPACK_VERSION=2.3.14 && bundle update"
    system "export ACTIONPACK_VERSION=2.3.14 && bundle exec rspec spec/rails2_spec.rb"
  end
end
