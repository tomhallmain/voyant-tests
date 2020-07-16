# frozen_string_literal: true

require_relative '../page_helper'

class ClientsPage
  include Capybara::DSL

  # Objects
  LOGO = "div[data-test-logo='true']"
  NAV_HEADER_SECTION = 'div.nav-header-section'
  TOP_NAV_DROPDOWN = 'div.top-nav-dropdown'
  RECENT_CLIENTS_BTN = "button[data-test-recentclients='true']"
  MY_CLIENTS_BTN = "button[data-test-myclients='true']"
  ALL_CLIENTS_BTN = "button[data-test-allclients='true']"
  SEARCH = "div[data-test-search='true']"
  SEARCH_BTN = "button.client-search-button"
  ADVANCED_SEARCH = "div[data-test-advancesearch='true']"
  ALL_FILTER = "button[data-test-letterfilter='ALL']"
  CLIENTS_TABLE = "table.client-list"
  CLIENT_ROW = "tr.test-clientList-clientRow"
  ADD_CLIENT_BTN = "button[data-test-add-button='true']"
  CREATED_SORT = "th[text='Created']"
  
  EDIT_MODAL_CONT = "div[data-test-edit-container-modal='true']"
  CANCEL_BTN = "button[data-test-model-cancel='true']"
  SAVE_BTN = "button[data-test-model-save='true']"
  NEW_CLIENT_FORM = "div[data-test-new-client-form='true']"
  NEW_CLIENT_NAME = "div[data-test-name='true']"
  NEW_CLIENT_FIRSTNAME = "div[data-test-firstname='true']"
  NEW_CLIENT_LASTNAME = "div[data-test-lastname='true']"
  NEW_CLIENT_BIRTHYEAR = "div[data-test-birthdayyear='true']"
  NEW_CLIENT_PROVINCE = "div[data-test-selectedprovince='true']"
  NEW_CLIENT_ISRETIRED = "div[data-test-isretired='true']"
  NEW_CLIENT_RETIREAGE = "div[data-test-retirementage='true']"
  NEW_CLIENT_ERROR_ALERT = 'div.alert-danger'
  NEW_CLIENT_ERROR_TEXT = "div[data-test-form-validation-error]"


  # Methods
  def clients_page_reached?
    page.has_css?(CLIENTS_TABLE)
  end

  def recent_clients_present?
    page.has_css?()
  end
  
  def letter_filter(letter)
    find("button[data-test-letterfilter='#{letter.upcase}']")
  end

  def client_row(exact=false, first_name=nil, last_name=nil)
    if exact
      find(CLIENT_ROW, text: "#{last_name}, #{first_name}", exact: true)
    elsif first_name.nil? || last_name.nil?
      first(CLIENT_ROW)
    else
      find(CLIENT_ROW, text: "#{last_name}, #{first_name}")
    end
  end

  def search_clients(query)
    find(SEARCH).find('input').set query
    first(SEARCH_BTN).click
    sleep 1
  end

  def validate_search(first_name, last_name)
    # NOTE: Searching for a name in the form as appears in the UI ("LastName, 
    # FirstName") will not match a given client record. Searching on other 
    # dimensions does not seem to be possible either.
    begin
      search_clients("#{first_name} #{last_name}")
      empty_result = 'No clients were found that match the current search criteria'
      name_text = first(CLIENT_ROW).find('td.name-text').text
      if name_text == empty_result
        'no results'
      elsif name_text.include?("#{last_name}, #{first_name}")
        true
      else
        raise "Search query for #{query} not found in result!"
      end
    rescue Capybara::ElementNotFound
      raise 'No client row element found!'
    end
  end
  
  def validate_page_elements
    begin
      within find('div.ember-application') do
        page.has_css?(LOGO)
        page.has_css?(NAV_HEADER_SECTION)
        first(NAV_HEADER_SECTION).text.include?('Invites Available')
        page.has_css?(TOP_NAV_DROPDOWN)
        page.has_css?(MY_CLIENTS_BTN)
        page.has_css?(ALL_CLIENTS_BTN)
        page.has_css?(SEARCH)
        page.has_css?(ADVANCED_SEARCH)
        page.has_css?(ALL_FILTER) && find(ALL_FILTER).text == 'ALL'
        letter_filter('Z').text == 'Z'
        page.has_css?(CLIENTS_TABLE)
        page.has_css?(ADD_CLIENT_BTN)
      end
    rescue Capybara::ElementNotFound
      false
    end
  end

  def add_client_initialize
    find(ADD_CLIENT_BTN).click
    begin
      page.has_css?(EDIT_MODAL_CONT)
    rescue Capybara::ElementNotFound
      false
    end
  end

  def validate_new_client_modal
    begin
      page.has_css?(CANCEL_BTN)
      page.has_css?(SAVE_BTN)
      page.has_css?(NEW_CLIENT_FORM)
      page.has_css?(NEW_CLIENT_NAME) && find(NEW_CLIENT_NAME).text == 'New Client'
      page.has_css?(NEW_CLIENT_FIRSTNAME)
      page.has_css?(NEW_CLIENT_LASTNAME)
      page.has_css?(NEW_CLIENT_BIRTHYEAR)
      page.has_css?(NEW_CLIENT_PROVINCE)
      page.has_css?(NEW_CLIENT_ISRETIRED)
      find(NEW_CLIENT_ISRETIRED).text.include?('Is this person already retired?')
      page.has_css?(NEW_CLIENT_RETIREAGE)
      page.has_css?(ADD_CLIENT_BTN)
    rescue Capybara::ElementNotFound
      false
    end
  end

  def validate_new_client_errors
    begin
      find(SAVE_BTN).click
      sleep 0.2
      page.has_css?(NEW_CLIENT_ERROR_ALERT)
      find(NEW_CLIENT_ERROR_ALERT).text.include?('3 errors were detected.')

      error_texts = all(NEW_CLIENT_ERROR_TEXT)
      error_texts[0].text == 'First name must not be blank'
      error_texts[1].text == 'Last name must not be blank'
      error_texts[2].text == 'Birthday year must be between 1900 - 2100'
    rescue Capybara::ElementNotFound
      false
    end
  end

  def complete_new_client(first_name, last_name, birth_year)
    begin
      find(NEW_CLIENT_FIRSTNAME).find('input').set first_name
      find(NEW_CLIENT_LASTNAME).find('input').set last_name
      find(NEW_CLIENT_BIRTHYEAR).find('input').set birth_year

      find(NEW_CLIENT_NAME).text == first_name
      find(NEW_CLIENT_ISRETIRED).text.include?("Is #{first_name} already retired?")

      find(SAVE_BTN).click
    rescue Capybara::ElementNotFound
      false
    end
  end

  def locate_client(first_name, last_name)
    begin
      # last_initial = last_name[0].upcase
      # letter_filter(last_initial).click
      # find('th', text: 'Created').click
      
      search_clients("#{last_name}, #{first_name}") unless page.has_selector?(RECENT_CLIENTS_BTN)
      client = client_row(true, first_name, last_name)
      raise 'Client not found!' unless client
      client
    rescue Capybara::ElementNotFound
      false
    end
  end

  def select_client(first_name, last_name)
    client_row = locate_client(first_name, last_name)
    client_row.click
  end

  def select_any_client
    client_row.click
  end
end
