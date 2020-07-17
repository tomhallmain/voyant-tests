
# frozen_string_literal: true

require_relative '../page_helper'

class LoginPage
  include Capybara::DSL

  # URLs
  LOGIN_URL = 'https://ca-test.planwithvoyant.com/advisergo/#/login'
  LOGIN_ROUTE = '#/login'

  # Objects
  LOGO = 'div.login-logo'
  LOGIN_FORM = "div[data-test-login-form='true']"
  EMAIL_FIELD = "div[data-test-username='true']"
  PASSWORD_FIELD = "div[data-test-password='true']"
  USE_2FA_CHKBOX = 'input[type=checkbox]'
  FORGOT_PASS_LINK = "a[data-test-forgotpassword='true']"
  SIGN_IN_BTN = "button[data-test-login='true']"
  CREATE_ACCT_LINK = "a[data-test-createaccount='true']"
  LANGUAGE_SELECT = 'select.form-control'
  LOADER = 'span.loader.tiny'
  INVALID_LOGIN_ALERT = "div[data-test-noaccesserror='true']"

  # Methods
  def login_page_reached?
    page.has_css?(LOGIN_FORM)
  end

  def invalid_login_alert_message
    find(INVALID_LOGIN_ALERT).text
  end

  def validate_login_form_elements
    selectors = [LOGIN_FORM, EMAIL_FIELD, PASSWORD_FIELD, USE_2FA_CHKBOX,
      FORGOT_PASS_LINK, SIGN_IN_BTN]

    Class.extend(PagesHelper).find_selectors(selectors)
 end
  
  def initiate_login(username, password)
    find(EMAIL_FIELD).find('input').set username
    find(PASSWORD_FIELD).find('input').set password
    find(SIGN_IN_BTN).click
    while page.has_css?(LOADER)
      sleep 0.1
    end
  end

  def login_app(username = nil, password = nil)
    visit LOGIN_ROUTE if current_url != LOGIN_URL
    if ( username.nil? || password.nil? )
      creds = YAML.load_file('spec/features/test_data/login_data.yml')
      username = creds['username']
      password = creds['password']
    end
    initiate_login(username, password)
  end
end

