include Warden::Test::Helpers
Warden.test_mode!
# Feature: CRUD
feature 'CRUD', :daily_currencies do

  before(:each) do
    @user = create(:user)
    login_as(@user, scope: :user)
  end

  after(:each) do
    Warden.test_reset!
  end

  scenario 'view all daily currencies' do
    currency = create(:daily_currency)

    visit daily_currencies_path

    expect(page).to have_content(currency.usd)
  end

  scenario 'create currency' do
    usd, eur = 28.55, 31.5
    create_daily_currency(usd: usd, eur: eur)

    expect(page).to have_content(usd)
    expect(page).to have_content(eur)
  end


  scenario 'impossible to create empty daily_currency' do
    create_daily_currency(usd: nil, eur: nil)

    expect(page).to have_content("New daily currency")
  end

  scenario 'display validation messages for empty daily_currency' do
    create_daily_currency(usd: nil, eur: nil)

    expect(page).to have_content("can't be blank")
  end

  scenario 'edit existing daily_currency', js: true do
    daily_currency = create(:daily_currency)
    new_usd, new_eur = 8.99, 9.99
    visit edit_daily_currency_path(daily_currency)
    update_daily_currency(usd: new_usd, eur: new_eur)

    expect(page).to have_content(new_usd)
    expect(page).to have_content(new_eur)
  end


  scenario 'impossible to update with empty' do
    daily_currency = create(:daily_currency)
    new_usd, new_eur = nil, nil
    visit edit_daily_currency_path(daily_currency)

    update_daily_currency(usd: new_usd, eur: new_eur)

    expect(page).to have_content("can't be blank")
  end

  scenario 'delete existing possible with im sure' do
    daily_currency = create(:daily_currency)
    delete_daily_currency

    expect(page).to have_content('Deleted successfully')
  end

  scenario 'raise not found for not existing id' do

    expect{visit_edit_page_for_not_existing_record}
    .to raise_error( ActionController::RoutingError)

  end

  def delete_daily_currency
    visit daily_currencies_path
    click_link "Delete"
  end

  def create_daily_currency(usd: , eur: )
    visit new_daily_currency_path

    fill_in('daily_currency_usd', with: usd)
    fill_in('daily_currency_eur', with: eur)
    fill_in('daily_currency_valid_on', with: "2017-02-03")

    click_button "Save currency"
  end

  def update_daily_currency(usd:, eur: )
    fill_in('daily_currency_usd', with: usd)
    fill_in('daily_currency_eur', with: eur)

    click_button "Update currency"
  end

  def visit_edit_page_for_not_existing_record
    id = 999
    visit edit_daily_currency_path(id: id)
  end

end
