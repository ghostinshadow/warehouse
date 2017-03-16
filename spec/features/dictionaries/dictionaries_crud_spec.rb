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

  scenario 'view dictionaries' do
    dictionary = create(:units_dictionary)
    visit dictionaries_path 

    expect(page).to have_content(dictionary.title)
  end

  scenario 'view materials dictionary' do
    dictionary = create(:materials_dictionary)
    visit dictionaries_path 

    expect(page).to have_content(dictionary.title)
  end

  scenario 'edit existing dictionary' do
    dictionary = create(:materials_dictionary)
    new_name = "materials new"

    update_dictionary(new_name)

    within_table("dictionaries") do
      expect(page).to have_content(new_name)
    end
  end

  scenario 'impossible to update with empty' do
    dictionary = create(:units_dictionary)

    update_dictionary('')

    be_on_edit_page
  end

  scenario 'raise not found for not existing' do
    id = 999

    expect{visit edit_dictionary_path(id: id)}.to raise_error( ActionController::RoutingError)
  end

  scenario 'show dictionary words', js: true do
    dictionary = create(:units_dictionary)
    word_name = "Inner word"
    dictionary.words << Word.new(body: word_name)

    visit dictionaries_path
    click_link "Words"

    expect(page).to have_content(word_name)
  end

  def update_dictionary(new_name)
    visit dictionaries_path
    click_link "Edit dictionary"
    fill_in("Title", with: new_name)
    click_button "Update dictionary"
  end

  def be_on_edit_page
    within("h3") do
      expect(page).to have_content("Edit dictionary")
    end
  end

end