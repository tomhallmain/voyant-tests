require 'rspec'
require 'date'
require 'pry-byebug'
require 'selenium-webdriver'
require 'capybara/rspec'
require 'yaml'
require 'webdrivers/chromedriver'
require 'features/page_helper'
require 'capybara_config'
#require 'screenshot_config'
require 'rspec_html_reporter'

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.after do |example|
    example_text = example.description.gsub(' ', '-').gsub(/^.*\/spec\//,'')
    filename = "screenshots/screenshot_#{example_text}_#{Date.today}.png"
    example.metadata[:screenshots] = [{path: Capybara.current_session.save_screenshot(filename)}]
    true
  end
end
