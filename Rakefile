require "bundler/gem_tasks"
task :default => :spec

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ["--format doc", "--color"]
end
