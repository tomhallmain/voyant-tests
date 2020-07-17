require 'rails'
require 'rake'
require 'date'

# To run headless, use rake -- -h
desc 'Run with no deprecation warnings from Ruby 2.7.0' 
task :tests do
  headless = ARGV[1] == '-h'
  ARGV.each { |a| task a.to_sym do ; end }
  ENV['RUBYOPT']='-W:no-deprecated -W:no-experimental'
  ENV['REPORT_PATH']="reports/#{Date.today.to_s}"
  if headless
    ENV['DRIVER']='headless'
    puts 'Running headless...'
  else 
    puts 'Running...'
  end
  `rspec --format RspecHtmlReporter`
  puts "output saved to #{ENV['REPORT_PATH']}"
end

task :default => :tests


