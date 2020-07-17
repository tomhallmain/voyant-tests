
# frozen_string_literal: true

require_relative '../page_helper'

class DashboardPage
  include Capybara::DSL

  # Objects
  CLIENT_ACTIONS_BTN = "button[data-test-clientactions='true']"
  NAV_LINK_SELECTED = 'span.nav-route-link-item.selected'
  NAV_LINK_DASHBOARD = "button[data-test-nav-link='home']"
  NAV_LINK_TIMELINE = "button[data-test-nav-link='timeline']"
  NAV_LINK_LETS_SEE = "button[data-test-nav-link='letsSee']" # Note casing
  NAV_LINK_INSIGHTS = "button[data-test-nav-link='insights']"
  NAV_LINK_LEGACY = "button[data-test-nav-link='legacy']"
  NAV_LINK_WHAT_IF = "button[data-test-nav-link='whatIf']" # Note casing
  NAV_LINK_REPORTS = "button[data-test-nav-link='reports']"
  CHART_TYPE = "button[data-test-chart-type='true']"
  CHART_DETAIL = "button[data-test-detailedone='true']"
  CHART_DRILLDOWN = "button[data-test-drilldownone='true']"
  ACCORDION_SECTION = 'div#accordion'
  NET_WORTH = "div[data-test-net-total='true']"
  PEOPLE_LINK = "a[data-test-accordion-header='people']"
  PLAN_SETTINGS_LINK = "a[data-test-accordion-header='Settings']" # Note proper case
  LETS_SEE_CHART = "div#letsseeChartSingle"
  ALLOCATION_SECTION = 'div#allocations'
  ADD_BTN = "button[data-test-add-button='true']"
  GOALS_LINK = "a[data-test-accordion-header='goals'"
  INCOME_LINK = "a[data-test-accordion-header='income'"
  INSURANCE_LINK = "a[data-test-accordion-header='protection']"

  ADD_BTN_MENU = 'div.add-button-menu' # See method below for generation of selectors
  ADD_MODAL = 'div#data-entry-modal'

  NEW_FORM_EXPENSE = "form[data-test-expense-basic-form='true']"
  NEW_FORM_TITLE = 'div.model-name-header'
  NEW_FORM_CLOSE_CONFIRM = "div[data-test-closeconfirmation='true']"
  NEW_FORM_CANCEL_BTN = "button[data-test-cancel='true']"
  NEW_FORM_DISCARD_BTN = "button[data-test-continue='true']"
  NEW_FORM_OWNER_BTN = "button[data-test-owner-button='true']"
  NEW_FORM_NAME = "div[data-test-name='true']"
  NEW_FORM_PRIORITY = "div[data-test-priority='true']"
  NEW_FORM_AMT = "div[data-test-amount='true']"
  NEW_FORM_TAX_DED = "div[data-test-debt-interesttaxdeductible='true']"
  NEW_FORM_RATE = "div[data-test-growthrate='true']"

  NEW_FORM_EMPLOYMENT = "form[data-test-ca-employment-form='true']"
  NEW_FORM_SOURCE = "div[data-test-employmentsource='true']"
  NEW_FORM_SALARY = "div[data-test-salary='true']"
  NEW_FORM_BONUS = "div[data-test-bonus='true']"
  NEW_FORM_BENEFITS = "div[data-test-benefitsinkind='true']"

  NEW_FORM_INSURANCE = "form[data-test-term-life-insurance-form='true']"
  NEW_FORM_TYPE = "div[data-test-type='true']"
  NEW_FORM_LINKED_EMP = 'div[data-test-employmentId]' # Note casing
  NEW_FORM_INSURED_DIFF = "div[data-test-insureddifferent='true']"
  NEW_FORM_SAL_MULT = "div[data-test-salarymultiplier='true']"
  NEW_FORM_INTRUST = "div[data-test-intrust='true']"
  
  EDIT_BASICS_BTN = "button[data-test-edit-tab='Basics']" # Note proper case for these
  EDIT_DETAILS_BTN = "button[data-test-edit-tab='Details']"
  EDIT_TIMING_BTN = "button[data-test-edit-tab='Timing']"
  EDIT_STEPS_BTN = "button[data-test-edit-tab='Steps']"
  EDIT_PMT_SOURCES_BTN = "button[data-test-edit-tab='Payment Sources']"
  EDIT_BENEFICIARIES_BTN = "button[data-test-edit-tab='Beneficiaries']"
  MODEL_VALIDATION_ERR = "div[data-test-model-validation='true']"
  FORM_VALIDATION_ERR = 'div[data-test-form-validation-error]'

  # Methods

  def dashboard_page_reached?
    begin
      find(NAV_LINK_DASHBOARD).has_css?(NAV_LINK_SELECTED)
    rescue Capybara::ElementNotFound
      false
    end
  end

  def validate_client_name(first_name, last_name)
    find(CLIENT_ACTIONS_BTN).find('strong.brand-bar-text').text == "#{last_name}, #{first_name}"
  end

  def validate_page_elements
    selectors = [CLIENT_ACTIONS_BTN, NAV_LINK_SELECTED, NAV_LINK_DASHBOARD,
      NAV_LINK_TIMELINE, NAV_LINK_LETS_SEE, NAV_LINK_INSIGHTS, NAV_LINK_LEGACY, 
      NAV_LINK_WHAT_IF, NAV_LINK_REPORTS, CHART_TYPE, CHART_DETAIL, CHART_DRILLDOWN,
      NET_WORTH, PEOPLE_LINK, LETS_SEE_CHART, ALLOCATION_SECTION, ADD_BTN]
    
    Class.extend(PagesHelper).find_selectors(selectors)

    page.has_css?(PLAN_SETTINGS_LINK) # There are two elements using the same data-test selector
  end

  def find_record(record)
    type = record[:type]
    name = record[:name]
    sleep 3 # There is a loading animation for the accordion rows
    begin
      accordion_row = case type
                      when 'goal' then find(GOALS_LINK)
                      when 'income' then find(INCOME_LINK)
                      when 'insurance' then find(INSURANCE_LINK)
                      end

      accordion_row.click
      accordion_row = Class.extend(PagesHelper).parent_of(accordion_row)
      accordion_row.has_content?(name)
    rescue Capybara::ElementNotFound
      false
    end
  end

  def open_add_btn_popup
    Class.extend(PagesHelper).scroll_to_top
    find(ADD_BTN).click unless page.has_css?(ADD_BTN_MENU)
  end

  def validate_add_btn_popup
    open_add_btn_popup
    types = %w[people companies goals event income savings-investments properties 
      debt protection expenses transfers drawdowns]

    types.map do |type|
      add_new_btn(type)
    end
    
    true
  end

  def add_new_btn(type)
    begin
      find(ADD_BTN_MENU).find("button[data-test-model-type='#{type}']")
    rescue Capybara::ElementNotFound
      raise "Add new button for #{type} not found!"
    end
  end

  def category_btn(category)
    find("li[data-test-model-category='#{category}']")
  end

  def select_category(category)
    category_btn(category).click
  end

  def goal_type_btn(goal_type)
    find("li[data-test-goal-type='goal-#{goal_type}']")
  end

  def select_goal_type(goal_type)
    goal_type_btn(goal_type).click
  end

  def initiate_add(type)
    open_add_btn_popup
    add_new_btn(type).click
  end

  def validate_category_options(type, options=[], headers=[])
    # Simple element validation for now
    begin
      find(ADD_MODAL).has_css?('span.h5', text: 'What type of item would you like to add?')
      
      options.each_with_index do |opt, i|
        opt_el = category_btn(opt)
        header_valid = opt_el.find('span.inline-link-no-help').text.include?(headers[i])
        raise "#{type} type #{opt} not found!" unless header_valid
      end
      true
    rescue Capybara::ElementNotFound
      false
    end
  end

  def validate_goal_options
    # Simple element validation for now
    begin
      options = %w[pre-retirement retirement milestone college]
      headers = ['Pre-Retirement Goal', 'Retirement Goal', 'Milestone Goal', 'Education Goal']
      descs = ['A yearly amount', 'A yearly amount', 'A one-time expense', 'A yearly amount' ]
      
      options.each_with_index do |goal_type, i|
        goal = goal_type_btn(goal_type)
        header_valid = goal.find('span.inline-link-no-help').text.include?(headers[i])
        desc_valid = goal.find('span.description-text').text.include?(descs[i])
        raise "Goal type #{goal_type} not found!" unless header_valid && desc_valid
      end
    rescue Capybara::ElementNotFound
      false
    end
  end
 
  def validate_add_preretirement_goal_elements
    selectors = [NEW_FORM_EXPENSE, NEW_FORM_TITLE, NEW_FORM_OWNER_BTN, NEW_FORM_NAME, 
      NEW_FORM_PRIORITY, NEW_FORM_AMT, NEW_FORM_TAX_DED, NEW_FORM_RATE,
      ClientsPage::CANCEL_BTN, ClientsPage::SAVE_BTN, EDIT_BASICS_BTN,
      EDIT_DETAILS_BTN, EDIT_TIMING_BTN, EDIT_STEPS_BTN, EDIT_PMT_SOURCES_BTN]

    Class.extend(PagesHelper).find_selectors(selectors)

    raise 'Title not found!' unless find(NEW_FORM_TITLE).text == 'Pre-Retirement Goal'

    true
  end

  def validate_add_preretirement_goal_errors
    begin 
      # Model validation errors are begin triggered upon attempting to leave
      # the page
      find(NAV_LINK_DASHBOARD).click
      error_test = 'Expenses must have an amount'
      error_text = find(FORM_VALIDATION_ERR).text
      find(MODEL_VALIDATION_ERR)
      find(NEW_FORM_CANCEL_BTN)
      find(NEW_FORM_DISCARD_BTN)
      confirm_test = 'You will lose any work that you have done so far. Are you sure?'
      confirm_text = first('div.alert-text').text
      find(NEW_FORM_CANCEL_BTN).click
      raise 'Form error or confirm text not found!' unless error_test == error_text && confirm_test == confirm_text

      true
    rescue Capybara::ElementNotFound
      false
    end
  end

  def set_preretirement_goal(name, amount)
    find(NEW_FORM_NAME).find('input').set name
    find(NEW_FORM_AMT).find('input').set amount
    find(ClientsPage::SAVE_BTN).click
    sleep 0.5
  end
  
  def validate_income_options
    options = %w[caEmployment caOther windfall caPensionPlan 
      caDefinedBenefitPension caOldAgeSecurity]
    headers = ['Employment', 'Other Income', 'Windfall', 'CPP/QPP', 
      'Defined Benefit Pension', 'Old Age Security']
    
    validate_category_options('Income', options, headers)
  end
  
  def initiate_add_income
    open_add_btn_popup
    add_new_btn('income').click
    type_category_btn('caEmployment').click
  end

  def validate_add_employment_income_elements
    selectors = [NEW_FORM_EMPLOYMENT, NEW_FORM_TITLE, NEW_FORM_OWNER_BTN, NEW_FORM_NAME, 
      NEW_FORM_SOURCE, NEW_FORM_SALARY, NEW_FORM_BONUS, NEW_FORM_BENEFITS,
      NEW_FORM_RATE, ClientsPage::CANCEL_BTN, ClientsPage::SAVE_BTN, 
      EDIT_BASICS_BTN, EDIT_TIMING_BTN, EDIT_STEPS_BTN]

    Class.extend(PagesHelper).find_selectors(selectors)

    raise 'Title not found!' unless find(NEW_FORM_TITLE).text == 'Employment'

    true
  end

  def validate_add_employment_income_errors
    begin 
      # Model validation errors are begin triggered upon attempting to leave
      # the page
      find(NAV_LINK_DASHBOARD).click
      error_test1 = 'Name must not be blank'
      error_text1 = first(FORM_VALIDATION_ERR).text
      error_test2 = 'Income must not be blank'
      error_text2 = all(FORM_VALIDATION_ERR)[1].text
      form_validations_found = error_test1 == error_text1 && error_test2 == error_text2
      page.has_css?(MODEL_VALIDATION_ERR)
      page.has_css?(NEW_FORM_CANCEL_BTN)
      page.has_css?(NEW_FORM_DISCARD_BTN)
      confirm_test = 'You will lose any work that you have done so far. Are you sure?'
      confirm_text = first('div.alert-text').text
      find(NEW_FORM_CANCEL_BTN).click
      raise 'Form error text not found!' unless form_validations_found
      raise 'Confirm text not found!' unless confirm_test == confirm_text
 
      true
    rescue Capybara::ElementNotFound
      false
    end
  end

  def set_employment_income(name, amount)
    find(NEW_FORM_NAME).find('input').set name
    find(NEW_FORM_SALARY).find('input').set amount
    find(ClientsPage::SAVE_BTN).click
    sleep 0.5
  end

  def validate_insurance_options
    options = %w[termLifeInsurance estimatedWholeLife disabilityInsurance 
      criticalIllnessInsurance longTermCareInsurance]
    headers = ['Term Life', 'Whole Life', 'Disability', 'Critical Illness', 
      'Long Term Care']
     
    validate_category_options('Insurance', options, headers)
  end
  
  def initiate_add_insurance
    open_add_btn_popup
    add_new_btn('protection').click
    type_category_btn('termLifeInsurance').click
  end

  def validate_add_term_life_elements
    selectors = [NEW_FORM_INSURANCE, NEW_FORM_TITLE, NEW_FORM_OWNER_BTN, 
      NEW_FORM_NAME, NEW_FORM_TYPE, NEW_FORM_LINKED_EMP, NEW_FORM_INSURED_DIFF,
      NEW_FORM_SAL_MULT, NEW_FORM_INTRUST, ClientsPage::CANCEL_BTN, 
      ClientsPage::SAVE_BTN, EDIT_BASICS_BTN, EDIT_BENEFICIARIES_BTN]

    Class.extend(PagesHelper).find_selectors(selectors)

    raise 'Title not found!' unless find(NEW_FORM_TITLE).text == 'Term Life'

    true
  end

  def validate_add_term_life_insurance_errors
    begin
      # Model validation errors are begin triggered upon attempting to leave
      # the page
      find(NAV_LINK_DASHBOARD).click
      error_test1 = 'Name must not be blank'
      error_text1 = first(FORM_VALIDATION_ERR).text
      error_test2 = 'Policy needs to be linked to an employment'
      error_text2 = all(FORM_VALIDATION_ERR)[1].text
      form_validations_found = error_test1 == error_text1 && error_test2 == error_text2
      find(MODEL_VALIDATION_ERR)
      find(NEW_FORM_CANCEL_BTN)
      find(NEW_FORM_DISCARD_BTN)
      confirm_test = 'You will lose any work that you have done so far. Are you sure?'
      confirm_text = first('div.alert-text').text
      find(NEW_FORM_CANCEL_BTN).click
      raise 'Form error text not found!' unless form_validations_found
      raise 'Confirm text not found!' unless confirm_test == confirm_text

      true
    rescue Capybara::ElementNotFound
      false
    end
  end
  
  def set_term_life_insurance(name, employment_name)
    find(NEW_FORM_NAME).find('input').set name
    select(employment_name)
    find(ClientsPage::SAVE_BTN).click
    sleep 0.5
  end
end

