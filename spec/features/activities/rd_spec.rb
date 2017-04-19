include Warden::Test::Helpers
Warden.test_mode!
# Feature: RD
feature 'RD', :activities do

  before(:each) do
    @user = create(:admin)
    login_as(@user, scope: :user)
  end

  after(:each) do
    Warden.test_reset!
  end

  context "words" do
    include_context "word activities"

    before(:each) do
      @dictionary = create(:materials_dictionary)
    end

    scenario 'list should contain word creation activity' do
      create_word("Hey you")
      visit activities_path

      expect(page).to have_content("created word")
      expect(page).to have_content(@user.email)
    end

    scenario "list should contain word edition activity" do
      word = create(:square_meter)
      new_body = "cubic"
      update_word(new_body)

      visit activities_path

      expect(page).to have_content(@user.email)
      expect(page).to have_content('updated word')
      expect(page).to have_content(new_body)
    end

    scenario "list should contain word deletion activity" do
      word = create(:square_meter)
      visit dictionary_words_path(@dictionary)
      click_link "Delete"

      visit activities_path

      expect(page).to have_content('deleted word')
    end
  end

  context "shippings" do
    include_context 'shipping activities'

    before(:each) do
      create_resources
    end

    scenario 'list should contain shipping creation activity', js: true do
      create_shipping{ select('Income', from: 'shipping_package_variant') }

      visit activities_path
      expect(page).to have_content('created Income')
    end

    scenario 'list should contain shipping creation activity', js: true do
      create_shipping{ select('Outcome', from: 'shipping_package_variant') }

      visit activities_path

      expect(page).to have_content('created Outcome')
    end

    scenario 'list should contain shipping destruction activity', js: true do
      create(:income_shipping)
      visit shippings_path
      click_link "Delete"

      visit activities_path

      expect(page).to have_content('deleted income')
    end
  end

  context "resources" do
    include_context "resource activities"

    scenario "list should contain resource creation activity", js: true do
      create_dictionaries
      create_countable_resource

      visit activities_path

      expect(page).to have_content('created metal')
    end

    scenario "list should contain resource update activity", js: true do
      materials, units = create_dictionaries
      resource = create(:countable_resource, name: materials.words.first, category: units.words.first)

      new_price = 999
      update_resource(new_price)

      visit activities_path

      expect(page).to have_content('updated resource')
    end

    scenario "list should contain resource deletion activity" do
      resource = create(:countable_resource)
      visit resources_path
      click_link "Delete"
      visit activities_path

      expect(page).to have_content('deleted resource')
    end
  end

  context 'dictionaries' do
    include_context "dictionary activities"

    scenario "list should contain dictionary update activity", js: true do
      dictionary = create(:materials_dictionary)
      new_name = "materials new"

      update_dictionary(new_name)

      visit activities_path

      expect(page).to have_content('updated dictionary')
    end

  end

  context 'daily_currencies' do
    include_context "daily_currencies activities"

    scenario "list should contain currency update activity", js: true do
      daily_currency = create(:daily_currency)
      new_usd, new_eur = 8.99, 9.99
      visit edit_daily_currency_path(daily_currency)
      update_daily_currency(usd: new_usd, eur: new_eur)

      visit activities_path

      expect(page).to have_content('updated currency for')
    end

    scenario "list should contain currency create activity", js: true do
      usd, eur = 28.55, 31.5
      create_daily_currency(usd: usd, eur: eur)

      visit activities_path

      expect(page).to have_content('created currency for')
    end

    scenario "list should contain currency delete activity", js: true do
      daily_currency = create(:daily_currency)
      delete_daily_currency

      visit activities_path

      expect(page).to have_content('deleted currency')
    end
  end

  context 'projects' do
    include_context 'shipping activities'
    include_context 'project activities'

    scenario "list should contain currency create activity", js: true do
      create_shipping_with_dependencies(*create_resources)
      create_project_with_implicit_prototype
      visit activities_path

      expect(page).to have_content('created project')
    end

    scenario "list should contain currency update activity", js: true do
      resource1, resource2 = create_resources
      @project = Project.create do |p|
        p.shipping = create_shipping_with_dependencies(resource1, resource2)
      end

      visit project_path(@project)
      click_link "Approve"
      visit activities_path

      expect(page).to have_content('approved project')
    end

    scenario "list should contain currency destroy activity", js: true do
      Project.create do |p|
        p.shipping = create_shipping_with_dependencies(*create_resources)
      end
      visit projects_path
      click_link "Delete"
      visit activities_path

      expect(page).to have_content('deleted project')
    end
  end

end
