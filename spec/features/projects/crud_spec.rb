include Warden::Test::Helpers
Warden.test_mode!
# Feature: CRUD
feature 'CRUD', :projects do
  include_context 'shipping activities'

  before(:each) do
    @user = create(:admin)
    login_as(@user, scope: :user)
  end

  after(:each) do
    Warden.test_reset!
  end

  scenario 'view all shippings' do
    project = Project.create do |p|
      p.shipping = create(:income_shipping)
    end
    visit projects_path

    expect(page).to have_content("Saved project")
  end

  scenario 'form fields visible' , js: true do
    visit new_project_path

    click_link "Add resource"
    wait_for_ajax
    labels = all("label").map(&:text)

    expect(labels).to include(*new_shipping_labels)
  end

  scenario 'create project manually', js: true do
    create_resources
    create_project

    expect(page).to have_content("Project created")
  end

  scenario 'create project using existing prototype', js: true do
    create_shipping_with_dependencies(*create_resources)
    create_project_with_implicit_prototype

    expect(page).to have_content("Project created")
  end

  scenario 'display validation messages for empty shipping' do
    create_resources
    visit new_shipping_path

    click_button "Save shipping"

    expect(page).to have_content("can't be blank")
  end

  describe "created project" do

    before(:example) do
      @project = Project.create do |p|
        p.shipping = create_shipping_with_dependencies(*create_resources)
      end
    end

    scenario 'delete existing possible with im sure' do

      visit projects_path
      click_link "Delete"

      expect(page).to have_content("Destroyed successfully")
    end


    scenario 'raise not found for not existing id' do
      expect{page.driver.submit :delete, project_path(id: 999), nil}
      .to raise_error( ActionController::RoutingError)
    end

    scenario "should be able to see details of created project", js: true do

      visit project_path(@project)

      expect(page).to have_content("Project details")
    end

    scenario "should display all details on show page", js: true do
      project = @project.decorate

      visit project_path(project)

      labels = all("h5").map(&:text)

      expect(page).to have_content(project.shipping_date)
      expect(page).to have_content('Outcome')
      expect(labels).to include("5 m2", "3 m3")
    end

    scenario "should show price in 3 currencies", js: true do

      visit projects_path
      click_link "Show"

      expect(page).to have_content('79.92')
      expect(page).to have_content('71.92')
      expect(page).to have_content('63.92')
    end

    scenario "should show state" do
      visit project_path(@project)

      expect(page).to have_content('Saved project')
    end

    scenario "should have approve button" do
      visit project_path(@project)

      click_link "Approve"
      
      expect(page).to have_content('Approved')
    end


  end

  scenario "can change resources by approving project" do
    resource1, resource2 = create_resources
    @project = Project.create do |p|
      p.shipping = create_shipping_with_dependencies(resource1, resource2)
    end

    visit project_path(@project)

    click_link "Approve"

    reload_resources([resource1, resource2])

    expect(resource1.count).to eq(BigDecimal('-3.5'))
    expect(resource2.count).to eq(BigDecimal('-1.5'))
  end

  def create_shipping_with_dependencies(resource1, resource2)
    project_prototype = create(:three_materials, structure: {resource1.id => 5, resource2.id => 3})
    create(:outcome_shipping, project_prototype: project_prototype)
  end

  def create_project
    create_shipping('project')
  end

  def create_project_with_implicit_prototype
    visit projects_path
    click_link "New project"

    click_link "Use Existing"
    wait_for_ajax

    fill_in('shipping_shipping_date', with: '2017-03-27')
    select('Project 23 - 2017-03-27', from: 'existing_prototype')

    click_button "Save project"
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
    ["Shipping date", "Resource", "Number", "Name"]
  end
end
