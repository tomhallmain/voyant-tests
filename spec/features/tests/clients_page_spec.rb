
describe 'Clients landing page', type: :feature, js: true do
  include PagesHelper

  before :all do
    visit '#/login'
    login_page.login_app
    @tc_first = 'Test'
    @tc_last = 'Client' + Random.rand(100..999).to_s
    @tc_byear = 1980
  end

  after :each do
    persist_browser
  end

  after :all do
    release_browser
  end

  context 'Page validations' do
    it 'validates clients landing page elements' do
      expect(clients_page.validate_page_elements).to be_truthy
      expect(page).not_to have_selector(ClientsPage::RECENT_CLIENTS_BTN)
    end
  end

  context "Clients page loaded and interactable" do
    it 'clicks add button and validates elements' do
      expect(clients_page.add_client_initialize).to be_truthy
      expect(clients_page.validate_new_client_modal).to be_truthy
    end

    it 'validates new client modal error case' do
      expect(clients_page.validate_new_client_errors).to be_truthy
    end

#    it 'adds a new client' do
#      expect(clients_page.complete_new_client(@tc_first, @tc_last, @tc_byear)).to be_truthy
#      expect(dashboard.dashboard_page_reached?).to be_truthy
#      expect(dashboard.validate_client_name(@tc_first, @tc_last)).to be_truthy
#    end
  end

#  context 'Checking for data persistence' do
#    it 'Validates recent clients' do
#      visit '#/advisor/clients'
#      expect(page).to have_selector(ClientsPage::RECENT_CLIENTS_BTN)
#    end

#    it 'Validates new client data in recent clients page' do
#      expect(clients_page.locate_client(@tc_first, @tc_last)).to be_truthy
#    end
    
#    it 'validates client search functionality' do
#      find(ClientsPage::MY_CLIENTS_BTN).click
#      expect(clients_page.validate_search(@tc_first, @tc_last)).to eq(true)
#      expect(clients_page.validate_search('BAD_CLIENT_NAME', '39423423')).to eq('no results') 
#    end
#  end
end

