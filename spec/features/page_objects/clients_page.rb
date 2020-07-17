# frozen_string_literal: true

require_relative '../page_helper'

class ClientsPage
  include Capybara::DSL

  # Objects
  LOGO = "div[data-test-logo='true']"
  NAV_HEADER_SECTION = 'div.nav-header-container'
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
  NEW_CLIENT_FORM = "form[data-test-new-client-form='true']"
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
    page.has_css?(RECENT_CLIENTS_BTN)
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
    selectors = [LOGO, NAV_HEADER_SECTION, TOP_NAV_DROPDOWN, MY_CLIENTS_BTN,
      ALL_CLIENTS_BTN, SEARCH, ADVANCED_SEARCH, ALL_FILTER, CLIENTS_TABLE,
      ADD_CLIENT_BTN]

    begin
      Class.extend(PagesHelper).find_selectors(selectors)

      valid = first(NAV_HEADER_SECTION).text.include?('Invites Available')
      valid = valid && find(ALL_FILTER).text == 'All'
      valid && letter_filter('Z').text == 'Z'
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
    selectors = [CANCEL_BTN, SAVE_BTN, NEW_CLIENT_FORM, NEW_CLIENT_NAME,
      NEW_CLIENT_FIRSTNAME, NEW_CLIENT_LASTNAME, NEW_CLIENT_BIRTHYEAR,
      NEW_CLIENT_PROVINCE, NEW_CLIENT_ISRETIRED, NEW_CLIENT_RETIREAGE,
      ADD_CLIENT_BTN]

    begin
      Class.extend(PagesHelper).find_selectors(selectors)
      valid = find(NEW_CLIENT_NAME).text == 'New Client'
      valid && find(NEW_CLIENT_ISRETIRED).text.include?('Is this person already retired?') 
    rescue Capybara::ElementNotFound
      false
    end
  end

  def validate_new_client_errors
    begin
      find(SAVE_BTN).click
      sleep 0.2
      find(NEW_CLIENT_ERROR_ALERT).text.include?('3 errors were detected.')

      error_texts = all(NEW_CLIENT_ERROR_TEXT)
      valid = error_texts[0].text == 'First name must not be blank'
      valid = valid && error_texts[1].text == 'Last name must not be blank'
      valid && error_texts[2].text == 'Birthday year must be between 1900 - 2100'
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
    search_clients("#{last_name}, #{first_name}") unless page.has_selector?(RECENT_CLIENTS_BTN)
    client = client_row(true, first_name, last_name)
    raise 'Client not found!' unless client
    client
  end

  def select_client(first_name, last_name)
    client_row = locate_client(first_name, last_name)
    client_row.click
  end

  def select_any_client
    client_row.click
  end
end
