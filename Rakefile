require 'rspec/core/rake_task'


RSpec::Core::RakeTask.new(:spec)

task :seed do
  if ENV["RACK_ENV"] == 'production'
    abort('cannot run in production')
  end

  require_relative 'seed'
  puts 'Seed complete'
end

namespace(:spec) do
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern = './spec/unit/*_spec.rb'
  end

  RSpec::Core::RakeTask.new(:quick) do |t|
    t.rspec_opts = "--tag ~type:feature"
  end

  RSpec::Core::RakeTask.new(:features) do |t|
    t.pattern = './spec/features/*_spec.rb'
  end
end
