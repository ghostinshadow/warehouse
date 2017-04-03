include Warden::Test::Helpers
Warden.test_mode!
# Feature: RD
feature 'RD', :activities do

  before(:each) do
    @user = create(:user)
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

      expect(page).to have_content("створив слово")
      expect(page).to have_content(@user.email)
    end

    scenario "list should contain word edition activity" do
      word = create(:square_meter)
      new_body = "cubic"
      update_word(new_body)

      visit activities_path

      expect(page).to have_content(@user.email)
      expect(page).to have_content('змінив слово')
      expect(page).to have_content(new_body)
    end

    scenario "list should contain word deletion activity" do
      word = create(:square_meter)
      visit dictionary_words_path(@dictionary)
      click_link "Delete"

      visit activities_path

      expect(page).to have_content('видалив слово')
    end
  end

  context "shippings" do
    include_context 'shipping activities'

    before(:each) do
      create_resources
    end

    scenario 'list should contain shipping creation activity', js: true do
      create_shipping{ select('IncomePackage', from: 'shipping_package_variant') }

      visit activities_path

      expect(page).to have_content('створив прихід')
    end

    scenario 'list should contain shipping creation activity', js: true do
      create_shipping{ select('OutcomePackage', from: 'shipping_package_variant') }

      visit activities_path

      expect(page).to have_content('створив розхід')
    end

    scenario 'list should contain shipping destruction activity', js: true do
      create(:income_shipping)
      visit shippings_path
      click_link "Delete"

      visit activities_path

      expect(page).to have_content('видалив прихід')
    end
  end

  context "resources" do
    include_context "resource activities"

    scenario "list should contain resource creation activity", js: true do
      create_dictionaries
      create_countable_resource

      visit activities_path

      expect(page).to have_content('створив ресурс')
    end

    scenario "list should contain resource update activity", js: true do
      materials, units = create_dictionaries
      resource = create(:countable_resource, name: materials.words.first, category: units.words.first)

      new_price = 999
      update_resource(new_price)

      visit activities_path

      expect(page).to have_content('оновив ресурс')
    end

    scenario "list should contain resource deletion activity" do
      resource = create(:countable_resource)
      visit resources_path
      click_link "Delete"
      visit activities_path

      expect(page).to have_content('видалив ресурс')
    end
  end

  context 'dictionaries' do
    include_context "dictionary activities"

    scenario "list should contain dictionary update activity", js: true do
      dictionary = create(:materials_dictionary)
      new_name = "materials new"

      update_dictionary(new_name)

      visit activities_path

      expect(page).to have_content('оновив словник')
    end

  end

end
