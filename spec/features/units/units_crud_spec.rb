include Warden::Test::Helpers
Warden.test_mode!
# Feature: CRUD
feature 'CRUD', :devise do

  before(:each) do
    @user = create(:user)
    login_as(@user, scope: :user)
  end

  after(:each) do
    Warden.test_reset!
  end

  # Scenario: User can sign in with valid credentials
  scenario 'create unit' do
    unit_name = "m3"
    visit units_path
    click_link "New unit"
    fill_in('Name', :with => unit_name)
    click_button "Create unit"

    expect(page).to have_content(unit_name)
  end

  scenario 'view all units' do
    unit_name = "m2"
    Unit.create!(name: unit_name)

    visit units_path

    expect(page).to have_content(unit_name)
  end

end
