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

  scenario 'view all resources' do
    resource = create(:countable_resource)
    resource = resource.decorate
    visit resources_path

    expect(page).to have_content(resource.name_body)
  end

  scenario 'form fields visible' , js: true do
    create_dictionaries
    visit new_resource_path

    labels = all("label").map(&:text)

    expect(labels).to include(*new_resource_labels)
  end

  scenario 'create resource countable', js: true do
    create_dictionaries
    create_countable_resource

    expect(page).to have_content("Created successfully")
  end

  scenario "create resource countless", js: true do
    create_dictionaries
  end

  scenario 'impossible to create empty resource', js: true do
    create_dictionaries
    visit new_resource_path

    click_button "Save resource"

    expect(page).to have_content("New resource")
  end

  scenario 'display validation messages for empty resource' do
    create_dictionaries
    visit new_resource_path

    click_button "Save resource"

    expect(page).to have_content("must exist")
  end

  scenario 'edit existing resource', js: true do
    materials, units = create_dictionaries
    resource = create(:countable_resource, name: materials.words.first, category: units.words.first)
    new_price = 999

    update_resource(new_price)

    expect(page).to have_content(new_price)
  end

  scenario 'delete existing possible with im sure' do
    resource = create(:countable_resource)
    visit resources_path
    click_link "Delete"

    expect(page).to have_content("Destroyed successfully")
  end

  scenario 'impossible to update with empty' do
    materials, units = create_dictionaries
    resource = create(:countable_resource, name: materials.words.first, category: units.words.first)

    visit edit_resource_path(resource)
    find('#resource_name_id').select(" ")
    
    be_on_edit_page
  end

  scenario 'raise not found for not existing id' do

    expect{visit_edit_page_for_not_existing_record}
    .to raise_error( ActionController::RoutingError)

  end

  def create_dictionaries
    m = create(:materials_dictionary)
    n = create(:units_dictionary)
    [m, n]
  end


  def visit_edit_page_for_not_existing_record
    id = 999
    visit edit_resource_path(id: id)
  end

  def create_countable_resource
    create_resource do
      select('Countable', from: 'resource_type')
    end
  end

  def create_countless_resource
    create_resource do
      select('Countless', from: 'resource_type')
    end
  end

  def create_resource(&block)
    visit resources_path
    click_link "New resource"
    choose_name_category_unit(&block)
    fill_price
    click_button "Save resource"
  end

  def fill_price
    fill_in('resource_price_uah', with: '45.23')
    fill_in('resource_price_usd', with: '2.23')
    fill_in('resource_price_eur', with: '4.23')
  end

  def choose_name_category_unit
    select('metal', from: 'resource_name_id')
    wait_for_ajax
    select('5mm', from: 'resource_category_id')
    select('m2', from: 'resource_unit_id')
    yield
  end

  def update_resource(new_price)
    visit resources_path
    click_link "Edit resource"

    fill_in("resource_price_usd", with: new_price)

    click_button "Update resource"
  end

  def be_on_edit_page
    within("h3") do
      expect(page).to have_content("Edit resource")
    end
  end

  def new_resource_labels
    ["Name", "Category", "Unit", "Type", "Price(uah)", "Price(usd)", "Price(eur)"]
  end
end
