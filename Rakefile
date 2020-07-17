require 'rails'
require 'rake'
require 'date'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = Dir.glob('spec/**/*_spec.rb')
  t.rspec_opts = '--format RspecHtmlReporter'
  # t.rspec_opts << " --out reports/test_results#{Date.today.to_s}.html"
  t.verbose = false
end

# To run headless, use rake -- -h
desc 'Run with no deprecation warnings from Ruby 2.7.0' 
task :tests do
  headless = ARGV[1] == '-h'
  ARGV.each { |a| task a.to_sym do ; end }
  ENV['RUBYOPT']='-W:no-deprecated -W:no-experimental'
  ENV['REPORT_PATH']="reports/#{Date.today.to_s}"
  if headless
    ENV['DRIVER']='headless'
    puts 'Running headless'
  end
  `rspec --format RspecHtmlReporter`
  # Rake::Task['spec'].invoke
end

task :default => :tests


