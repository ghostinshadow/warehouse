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

  scenario 'view all shippings' do
    shipping = create(:income_shipping)
    visit shippings_path

    expect(page).to have_content(shipping.shipping_date)
  end

  scenario 'form fields visible' , js: true do
    visit new_shipping_path
    
    click_link "Add resource"
    wait_for_ajax
    labels = all("label").map(&:text)

    expect(labels).to include(*new_shipping_labels)
  end

  scenario 'create shipping income', js: true do
    create_resources
    create_shipping{ select('IncomePackage', from: 'shipping_package_variant') }

    expect(page).to have_content("Shipping created")
  end

  scenario 'create shipping income', js: true do
    create_resources
    create_shipping{ select('OutcomePackage', from: 'shipping_package_variant') }

    page.save_screenshot
    expect(page).to have_content("Shipping created")
  end

  scenario 'display validation messages for empty shipping' do
    create_resources
    visit new_shipping_path

    click_button "Save shipping"

    expect(page).to have_content("can't be blank")
  end


  # scenario 'delete existing possible with im sure' do
  #   shipping = create(:countable_shipping)
  #   visit shippings_path
  #   click_link "Delete"

  #   expect(page).to have_content("Destroyed successfully")
  # end

  # scenario 'impossible to update with empty' do
  #   materials, units = create_dictionaries
  #   shipping = create(:countable_shipping, name: materials.words.first, category: units.words.first)

  #   visit edit_shipping_path(shipping)
  #   find('#shipping_name_id').select(" ")
    
  #   be_on_edit_page
  # end

  # scenario 'raise not found for not existing id' do

  #   expect{visit_edit_page_for_not_existing_record}
  #   .to raise_error( ActionController::RoutingError)

  # end

  def create_resources
    create(:countable_resource_bottom)
    create(:countable_resource)
  end


  def visit_edit_page_for_not_existing_record
    id = 999
    visit edit_shipping_path(id: id)
  end

  def create_shipping(&block)
    visit shippings_path
    click_link "New shipping"

    choose_date_and_type(&block)

    fill_prototype_name("87ui")

    fill_resource("metal", 5)

    fill_resource("bottom", 6.7)

    click_button "Save shipping"
  end

  def fill_prototype_name(value)
    fill_in("project_prototype_name", with: value)
  end

  def fill_resource(option, value)
    @count ||= 1
    click_link "Add resource"
    wait_for_ajax
    select(option, from: "project_prototype_resource_id_#{@count}")
    fill_in("project_prototype_resource_name_#{@count}", with: value)
    @count += 1
  end

  def choose_date_and_type
    fill_in( 'shipping_shipping_date', with: '2017-03-273')
    yield
  end

  def update_shipping(new_price)
    visit shippings_path
    click_link "Edit shipping"

    fill_in("shipping_price_usd", with: new_price)

    click_button "Update shipping"
  end

  def be_on_edit_page
    within("h3") do
      expect(page).to have_content("Edit shipping")
    end
  end

  def new_shipping_labels
    ["Type", "Shipping date", "Resource", "Number", "Name"]
  end
end
