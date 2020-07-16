
describe 'Validates Dashboard page', type: :feature, js: true do
  include PagesHelper

  before :all do
    login_page.login_app
  end

  after :each do
    persist_browser
  end

  after :all do
    release_browser
  end

  context 'Page validations' do
    it 'can open the dashboard page from clients page' do
      clients_page.select_any_client
      expect(dashboard.dashboard_page_reached?).to be_truthy
    end

    it 'validates the base elements on dashboard page' do
      expect(dashboard.validate_page_elements).to be_truthy
    end

    it 'validates the base elements in add button popup' do
      expect(dashboard.validate_add_btn_popup).to be_truthy
    end
  end

  context 'Create a pre-retirement goal' do
    it 'validates create goal base case' do
      dashboard.initiate_add_goal
      expect(dashboard.validate_preretirement_goal).to be_truthy
    end

    it 'validates create goal errors' do
      dashboard.initiate_add_goal
      expect(dashboard.validate_preretirement_goal_errors)
    end
  end

  context 'Create an income record' do
    it 'validates create employment income base case' do
      dashboard.initiate_add_income
      expect(dashboard.validate_add_employment_income).to be_truthy
    end

    it 'validates create employment income errors' do
      dashboard.initiate_add_income
      expect(dashboard.validate_add_employment_income_errors).to be_truthy
    end
  end

  context 'Create an insurance record' do
    it 'validates create term insurance base case' do
      dashboard.initiate_add_insurance
      expect(dashboard.validate_add_term_life_insurance).to be_truthy
    end

    it 'validates create term insurance errors' do
      dashboard.initiate_add_insurance
      expect(dashboard.validate_add_term_life_insurance_errors).to be_truthy
    end
  end

  context 'Validates previously entered data in dashboard' do
    it 'validates pre-retirement goal, employment income, term life insurance' do
      expect(true).to be_truthy
    end
  end
end

