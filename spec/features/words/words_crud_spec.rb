include Warden::Test::Helpers
Warden.test_mode!
# Feature: CRUD
feature 'CRUD', :devise do

  before(:each) do
    @user = create(:user)
    login_as(@user, scope: :user)
    @dictionary = create(:materials_dictionary)
  end

  after(:each) do
    Warden.test_reset!
  end

  scenario 'view all words' do
    word = create(:square_meter)

    visit dictionary_words_path(word.dictionary)

    expect(page).to have_content(word.body)
  end

  scenario 'create word' do
    word_body = "m3"
    create_word(word_body)

    expect(page).to have_content(word_body)
  end

  scenario 'impossible to create empty word' do
    create_word('')

    expect(page).to have_content("New word")
  end

  scenario 'display validation messages for empty word' do
    create_word('')

    expect(page).to have_content("can't be blank")
  end

  scenario 'edit existing word' do
    word = create(:square_meter)
    new_body = "cubic"

    update_word(new_body)

    within_table("words") do
      expect(page).to have_content(new_body)
    end
  end

  scenario 'impossible to update with empty' do
    word = create(:square_meter)

    update_word('')

    be_on_edit_page
  end

  scenario 'raise not found for not existing id' do
    id = 999

    expect{visit edit_dictionary_word_path(@dictionary, id: id)}
    .to raise_error( ActionController::RoutingError)
  end

  scenario 'raise not found for not existing dictionary' do
    id = 84
    expect{visit edit_dictionary_word_path(dictionary_id: id, id: id)}
    .to raise_error( ActionController::RoutingError)
  end

  def create_word(word_body)
    visit dictionary_words_path(@dictionary)
    click_link "New word"
    fill_in('Body', :with => word_body)
    click_button "Create word"
  end

  def update_word(new_body)
    visit dictionary_words_path(@dictionary)
    click_link "Edit word"
    fill_in("Body", with: new_body)
    click_button "Update word"
  end

  def be_on_edit_page
    within("h3") do
      expect(page).to have_content("Edit word")
    end
  end

end
