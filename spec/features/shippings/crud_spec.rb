include Warden::Test::Helpers
Warden.test_mode!
# Feature: CRUD
feature 'CRUD', :shippings do
  include_context 'shipping activities'
  
  before(:each) do
    @user = create(:admin)
    login_as(@user, scope: :user)
  end

  after(:each) do
    Warden.test_reset!
  end

  scenario 'view all shippings' do
    shipping = create(:income_shipping)
    shipping = shipping.decorate
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
    create_shipping{ select('Income', from: 'shipping_package_variant') }

    expect(page).to have_content("Created successfully")
  end

  scenario 'create shipping outcome', js: true do
    create_resources
    create_shipping{ select('Outcome', from: 'shipping_package_variant') }

    expect(page).to have_content("Created successfully")
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
    create_shipping{ select('Income', from: 'shipping_package_variant') }
    resource1.reload
    resource2.reload

    expect(resource1.count).to eq(BigDecimal('8.2'))
    expect(resource2.count).to eq(BigDecimal('6.5'))
  end

  scenario 'outcoming shipping save should change resource count', js: true do
    resource1, resource2 = create_resources

    visit new_shipping_path
    create_shipping{ select('Outcome', from: 'shipping_package_variant') }
    reload_resources([resource1, resource2])

    expect(resource1.count).to eq(BigDecimal('-5.2'))
    expect(resource2.count).to eq(BigDecimal('-3.5'))
  end


  scenario 'delete existing possible with im sure' do
    resource1, resource2 = create_resources
    create_shipping_with_dependencies(resource1, resource2)

    visit shippings_path
    click_link "Delete"

    expect(page).to have_content("Deleted successfully")
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

  scenario "should be able to see details of created shipping" do
    resource1, resource2 = create_resources
    create_shipping_with_dependencies(resource1, resource2)

    visit shippings_path
    click_link "Show"

    expect(page).to have_content("Shipping details")
  end

  scenario "should display all details on show page", js: true do
    resource1, resource2 = create_resources
    shipping = create_shipping_with_dependencies(resource1, resource2)

    visit shippings_path
    click_link "Show"
    labels = all("h5").map(&:text)

    expect(page).to have_content(shipping.shipping_date.strftime("%d/%m/%Y"))
    expect(page).to have_content('Income')
    expect(labels).to include("5 m2", "3 m3")
  end

  scenario "should calculate money on show page", js: true do
    resource1, resource2 = create_resources
    shipping = create_shipping_with_dependencies(resource1, resource2)

    visit shippings_path
    click_link "Show"

    expect(page).to have_content("Sum")
  end

  scenario "should show price in 3 currencies", js: true do
    resource1, resource2 = create_resources
    shipping = create_shipping_with_dependencies(resource1, resource2)

    visit shippings_path
    click_link "Show"

    expect(page).to have_content('79.92')
    expect(page).to have_content('71.92')
    expect(page).to have_content('63.92')
  end

  def create_shipping_with_dependencies(resource1, resource2)
    project_prototype = create(:three_materials, structure: {resource1.id => 5, resource2.id => 3})
    create(:income_shipping, project_prototype: project_prototype)
  end

  def reload_resources(resources)
    resources.each(&:reload)
  end

  def visit_edit_page_for_not_existing_record
    id = 999
    visit edit_shipping_path(id: id)
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
