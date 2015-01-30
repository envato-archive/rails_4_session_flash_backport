require "bundler/gem_tasks"

namespace :spec do
  task :rails2 do
    Bundler.with_clean_env do
      ENV["BUNDLE_GEMFILE"] = File.expand_path("../gemfiles/Gemfile.rails2", __FILE__)

      system "bundle", "check" or
        system "bundle" or
        raise "Couldn't install bundle from gemfiles/Gemfile.rails2"

      system "bundle", "exec", "rspec", "--color", "spec/rails2" or
        fail
    end
  end

  task :rails3 do
    Bundler.with_clean_env do
      ENV["BUNDLE_GEMFILE"] = File.expand_path("../gemfiles/Gemfile.rails3", __FILE__)

      system "bundle", "check" or
        system "bundle" or
        raise "Couldn't install bundle from gemfiles/Gemfile.rails3"

      system "bundle", "exec", "rspec", "--color", "spec/rails3" or
        fail
    end
  end
end

task :spec => ["spec:rails2", "spec:rails3"]

task :default => :spec
