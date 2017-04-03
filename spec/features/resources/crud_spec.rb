include Warden::Test::Helpers
Warden.test_mode!
# Feature: CRUD
feature 'CRUD', :resources do
  include_context "resource activities"
  
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
    create_countless_resource

    expect(page).to have_content("Created successfully")
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

  def visit_edit_page_for_not_existing_record
    id = 999
    visit edit_resource_path(id: id)
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
