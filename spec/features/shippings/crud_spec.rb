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

  scenario 'create shipping outcome', js: true do
    create_resources
    create_shipping{ select('OutcomePackage', from: 'shipping_package_variant') }

    expect(page).to have_content("Shipping created")
  end

  scenario 'display validation messages for empty shipping' do
    create_resources
    visit new_shipping_path

    click_button "Save shipping"

    expect(page).to have_content("can't be blank")
  end

  scenario 'shipping save should change resource count', js: true do
    resource1, resource2 = create_resources

    visit new_shipping_path
    create_shipping{ select('IncomePackage', from: 'shipping_package_variant') }
    resource1.reload
    resource2.reload

    expect(resource1.count).to eq(BigDecimal('8.2'))
    expect(resource2.count).to eq(BigDecimal('6.5'))
  end

  scenario 'outcoming shipping save should change resource count', js: true do
    resource1, resource2 = create_resources

    visit new_shipping_path
    create_shipping{ select('OutcomePackage', from: 'shipping_package_variant') }
    reload_resources([resource1, resource2])

    expect(resource1.count).to eq(BigDecimal('-5.2'))
    expect(resource2.count).to eq(BigDecimal('-3.5'))
  end


  scenario 'delete existing possible with im sure' do
    resource1, resource2 = create_resources
    create_shipping_with_dependencies(resource1, resource2)

    visit shippings_path
    click_link "Delete"

    expect(page).to have_content("Destroyed successfully")
  end

  scenario 'delete should change number of resources' do
    resource1, resource2 = create_resources
    create_shipping_with_dependencies(resource1, resource2)
    
    visit shippings_path
    click_link "Delete"
    reload_resources([resource1, resource2])

    expect(resource1.count).to eq(BigDecimal('-3.5'))
    expect(resource2.count).to eq(BigDecimal('-1.5'))
  end

  scenario 'raise not found for not existing id' do
    expect{page.driver.submit :delete, shipping_path(id: 999), nil}
    .to raise_error( ActionController::RoutingError)
  end

  def create_resources
    r1 = create(:countable_resource_bottom)
    r2 = create(:countable_resource)
    [r1, r2]
  end

  def create_shipping_with_dependencies(resource1, resource2)
    project_prototype = create(:three_materials, structure: {resource1.id => 5, resource2.id => 3})
    shipping = create(:income_shipping, project_prototype: project_prototype)
  end

  def reload_resources(resources)
    resources.each(&:reload)
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
    select(option, from: "project_prototype_structure_resource_id_#{@count}")
    fill_in("project_prototype_structure_resource_name_#{@count}", with: value)
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
