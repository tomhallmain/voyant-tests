
# frozen_string_literal: true

require_relative '../page_helper'

class DashboardPage
  include Capybara::DSL

  # Objects
  CLIENT_ACTIONS_BTN = "button[data-test-clientactions='true']"
  NAV_LINK_SELECTED = 'span.nav-route-link-item.selected'
  NAV_LINK_DASHBOARD = "button[data-test-nav-link='home']"
  ADD_BTN = "button[data-test-add-button='true']"


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

  end

  def validate_add_btn_popup
    find(ADD_BTN).click

  end

  def add_new_btn(type)
    find("div[data-test-model-type='#{type}']")
  end

  def type_category_btn(category)
    find("div[data-test-model-category='#{category}']")
  end

  def goal_type_btn(type)
    find("li[data-test-goal-type='#{type}']")
  end

  def initiate_add_goal(goal_type)
    add_new_btn('goal').click
    goal_type_btn('goal-pre-retirement').click
  end

  def validate_preretirement_goal

  end
  
  def validate_preretirement_goal_errors

  end

  def initiate_add_income
    add_new_btn('income').click
    type_category_btn('caEmployment').click
  end

  def validate_add_employment_income

  end

  def validate_add_employment_income_errors

  end

  def initiate_add_insurance
    add_new_btn('insurance').click
    type_category_btn('termLifeInsurance').click
  end

  def validate_add_term_life_insurance
  end
  
  def validate_add_term_life_insurance_errors
  end
end


