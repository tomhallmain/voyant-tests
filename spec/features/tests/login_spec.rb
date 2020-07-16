
describe 'Login to Voyant demo', type: :feature, js: true do
  include PagesHelper

  before :all do
    creds = YAML.load_file('spec/features/test_data/login_data.yml')
    @username = creds['username']
    @password = creds['password']
  end

  before :each do
    visit LoginPage::LOGIN_ROUTE
  end

  context 'Page validations' do
    it 'can open the login page' do
      expect(login_page.login_page_reached?).to be_truthy
    end

    it 'validates the login form on the login page' do
      expect(login_page.validate_login_form_elements).to be_truthy
    end
  end

  context "with valid login data" do
    it 'allows user to login with valid username and password' do
      login_page.login_app(@username, @password)
      expect(current_url).to eq('https://ca-test.planwithvoyant.com/advisergo/#/advisor/clients')
    end
  end

  context 'with invalid Login data' do
    it 'shows invalid message and console error with bad email' do
      login_page.initiate_login('bad_email@example.com', @password)
      expect(login_page.invalid_login_alert_message).to eq('Incorrect credentials')
      expect{ console_check }.to raise_error(JavaScriptConsoleError)
    end

    it 'shows invalid message and console error with bad password' do
      login_page.initiate_login(@username, 'badPassword')
      expect(login_page.invalid_login_alert_message).to eq('Incorrect credentials')
      expect{ console_check }.to raise_error(JavaScriptConsoleError)
    end

#    it 'temporarily locks the user out after too many invalid attempts' do
#      4.times do
#        visit '#/login'
#        expect(login_page.login_page_reached?).to be_truthy
#        login_page.initiate_loginlogin(@username, 'badPassword')
#      end
#
#      lockout_message = "This account has been locked due to too many failed sign in attempts."
#      expect(login_page.invalid_login_alert_message).to include(lockout_message)
#    end
  end
end

