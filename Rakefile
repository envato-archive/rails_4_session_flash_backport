require "bundler/gem_tasks"

namespace :spec do
  task :rails3 do
    system "export ACTIONPACK_VERSION=3.2.9 && bundle check > /dev/null || bundle update"
    puts "Running Rails 3 specs"
    system "export ACTIONPACK_VERSION=3.2.9 && bundle exec rspec --color spec/rails3_spec.rb"
    puts ""
  end

  task :rails2 do
    system "export ACTIONPACK_VERSION=2.3.14 && bundle check > /dev/null || bundle update"
    puts "Running Rails 2 specs"
    system "export ACTIONPACK_VERSION=2.3.14 && bundle exec rspec --color spec/rails2_spec.rb"
    puts ""
  end
end

task :spec => ["spec:rails2", "spec:rails3"]
