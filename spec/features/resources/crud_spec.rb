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
    create(:materials_dictionary)
    create(:units_dictionary)
    visit new_resource_path
    
    labels = all("label").map(&:text)

    expect(labels).to include(*new_resource_labels)
  end

  scenario 'create resource', js: true do
    create(:materials_dictionary)
    create(:units_dictionary)
    create_resource

    expect(page).to have_content("Created successfully")
  end

  # scenario 'impossible to create empty resource' do
  #   create_resource('')

  #   expect(page).to have_content("New resource")
  # end

  # scenario 'display validation messages for empty resource' do
  #   create_resource('')

  #   expect(page).to have_content("can't be blank")
  # end

  # scenario 'edit existing resource', js: true do
  #   resource = create(:square_meter)
  #   new_body = "cubic"
  #   update_resource(new_body)
  #   within_table("resources") do
  #     expect(page).to have_content(new_body)
  #   end
  # end

  # scenario 'delete existing possible with im sure' do
  #   resource = create(:square_meter)
  #   visit dictionary_resources_path(@dictionary)
  #   click_link "Delete"

  #   within_table("resources") do
  #     expect(page).not_to have_content(resource.body)
  #   end
  # end

  # scenario 'impossible to update with empty' do
  #   resource = create(:square_meter)

  #   update_resource('')

  #   be_on_edit_page
  # end

  # scenario 'raise not found for not existing id' do

  #   expect{visit_edit_page_for_not_existing_record}
  #   .to raise_error( ActionController::RoutingError)
    
  # end

  # scenario 'raise not found for not existing dictionary' do
    
  #   expect{visit_resources_index_for_not_existing_dictionary}
  #   .to raise_error( ActionController::RoutingError)
    
  # end

  def visit_resources_index_for_not_existing_dictionary
    id = 84
    visit dictionary_resources_path(dictionary_id: id)
  end

  def visit_edit_page_for_not_existing_record
    id = 999
    visit edit_dictionary_resource_path(@dictionary, id: id)
  end

  def create_resource
    visit resources_path
    click_link "New resource"
    choose_name_category_unit_type
    fill_price

    click_button "Save resource"
  end

  def fill_price
    fill_in('resource_price_uah', with: '45.23')
    fill_in('resource_price_usd', with: '2.23')
    fill_in('resource_price_eur', with: '4.23')
  end

  def choose_name_category_unit_type
    select('metal', from: 'resource_name_id')
    wait_for_ajax
    select('5mm', from: 'resource_category_id')
    select('m2', from: 'resource_unit_id')
    select('Countless', from: 'resource_type')
  end

  def update_resource
    visit dictionary_resources_path(@dictionary)
    click_link "Edit resource"
    fill_in("Body", with: new_body)

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