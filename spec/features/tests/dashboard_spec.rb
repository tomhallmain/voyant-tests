
describe 'Validates Dashboard page', type: :feature, js: true do
  include PagesHelper

  before :all do
    login_page.login_app
    clients_page.select_any_client
    @goal_name = 'Test Pre-Retirement Goal ' + Random.rand(100..999).to_s
    @goal_amount = Random.rand(100000..999999)
    @income_name = 'Test Employment Income ' + Random.rand(100..999).to_s
    @income_amount = Random.rand(100000..400000)
    @insurance_name = 'Test Term Life Insurance ' + Random.rand(100..999).to_s
  end

  after :each do
    persist_browser
  end

  after :all do
    release_browser
  end

  context 'Page validations' do
    it 'can open the dashboard page from clients page' do
      expect(dashboard.dashboard_page_reached?).to be_truthy
    end

    it 'validates the base elements on dashboard page' do
      expect(dashboard.validate_page_elements).to be_truthy
    end

    it 'validates the base elements in add button popup' do
      expect(dashboard.validate_add_btn_popup).to be_truthy
    end
  end

  context 'Create and validate a pre-retirement goal' do
    it 'validates goal options and preretirement goal setup' do
      dashboard.initiate_add('goals')
      expect(dashboard.validate_goal_options).to be_truthy
      dashboard.select_goal_type('pre-retirement')
      expect(dashboard.validate_add_preretirement_goal_elements).to be_truthy
    end

    it 'validates create goal errors' do
      expect(dashboard.validate_add_preretirement_goal_errors)
    end

    it 'sets pre-retirement goal' do
      expect(dashboard.set_preretirement_goal(@goal_name, @goal_amount)).to be_truthy
    end
    
    it 'validates pre-retirement goal persistence' do
      record = {type: 'goal', name: @goal_name}
      expect(dashboard.find_record(record)).to be_truthy
    end
  end

  context 'Create and validate an income record' do
    it 'validates income options and employment income setup' do
      dashboard.initiate_add('income')
      expect(dashboard.validate_income_options).to be_truthy
      dashboard.select_category('caEmployment')
      expect(dashboard.validate_add_employment_income_elements).to be_truthy
    end

    it 'validates create employment income errors' do
      expect(dashboard.validate_add_employment_income_errors).to be_truthy
    end
    
    it 'sets income' do
      expect(dashboard.set_employment_income(@income_name, @income_amount)).to be_truthy
    end
    
    it 'validates employment income persistence' do
      record = {type: 'income', name: @income_name}
      expect(dashboard.find_record(record)).to be_truthy
    end
  end

  context 'Create and validate an insurance record' do
    it 'validates insurance options and term life insurance setup' do
      dashboard.initiate_add('protection')
      expect(dashboard.validate_insurance_options).to be_truthy
      dashboard.select_category('termLifeInsurance')
      expect(dashboard.validate_add_term_life_elements).to be_truthy
    end

    it 'validates create term life insurance errors' do
      expect(dashboard.validate_add_term_life_insurance_errors).to be_truthy
    end

    it 'sets term life insurance' do
      expect(dashboard.set_term_life_insurance(@insurance_name, @income_name)).to be_truthy
    end
    
    it 'validates term life insurance persistence' do
      record = {type: 'insurance', name: @insurance_name}
      expect(dashboard.find_record(record)).to be_truthy
    end
  end
end

