require 'capybara/rspec'
#require 'capybara-screenshot/rspec'

# Screenshot settings

#Capybara::Screenshot.autosave_on_failure = false
#Capybara::Screenshot.prune_strategy = :keep_last_run
#Capybara::Screenshot::RSpec::REPORTERS["RSpec::Core::Formatters::HtmlFormatter"] = Capybara::Screenshot::RSpec::HtmlEmbedReporter

#driver_sym = ENV['DRIVER'] == 'headless' ? :headless_chrome : :chrome
#Capybara::Screenshot.register_driver(driver_sym) do |driver, path|
#  driver.browser.save_screenshot(path)
#end

#Capybara::Screenshot.register_filename_prefix_formatter(:rspec) do |example|
#  "screenshot_#{example.description.gsub(' ', '-').gsub(/^.*\/spec\//,'')}"
#end


#module MyReporter
#  extend Capybara::Screenshot::RSpec::BaseReporter

  # Will replace the formatter's original `dump_failure_info` method with
  # `dump_failure_info_with_screenshot` from this module:
#  enhance_with_screenshot :dump_failure_info

#  def dump_failure_info_with_screenshot(example)
#    dump_failure_info_without_screenshot(example) # call original implementation
    # your additions here
#  end
#end

