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

  scenario 'view unit type dictionary' do
    dictionary = create(:units_dictionary)
    visit dictionaries_path 

    expect(page).to have_content(dictionary.title)
  end

  scenario 'view materials dictionary' do
    dictionary = create(:materials_dictionary)
    visit dictionaries_path 

    expect(page).to have_content(dictionary.title)
  end

  # scenario 'create dictionary' do
  #   dictionary_name = "m3"
  #   create_dictionary(dictionary_name)

  #   expect(page).to have_content(dictionary_name)
  # end

  # scenario 'impossible to create empty dictionary' do
  #   create_dictionary('')

  #   expect(page).to have_content("New dictionary")
  # end

  # scenario 'display validation messages for empty dictionary' do
  #   create_dictionary('')

  #   expect(page).to have_content("can't be blank")
  # end

  # scenario 'edit existing dictionary' do
  #   dictionary = create(:square_meter)
  #   new_name = "cubic"

  #   update_dictionary(new_name)

  #   within_table("dictionaries") do
  #     expect(page).to have_content(new_name)
  #   end
  # end

  # scenario 'impossible to update with empty' do
  #   dictionary = create(:square_meter)

  #   update_dictionary('')

  #   be_on_edit_page
  # end

  # scenario 'raise not found for not existing' do
  #   id = 999

  #   expect{visit edit_dictionary_path(id: id)}.to raise_error( ActionController::RoutingError)
  # end

  # def create_dictionary(dictionary_name)
  #   visit dictionaries_path
  #   click_link "New dictionary"
  #   fill_in('Name', :with => dictionary_name)
  #   click_button "Create dictionary"
  # end

  # def update_dictionary(new_name)
  #   visit dictionaries_path
  #   click_link "Edit dictionary"
  #   fill_in("Name", with: new_name)
  #   click_button "Update dictionary"
  # end

  # def be_on_edit_page
  #   within("h3") do
  #     expect(page).to have_content("Edit dictionary")
  #   end
  # end

end
