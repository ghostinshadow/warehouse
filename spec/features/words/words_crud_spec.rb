require "rails_helper"
include Warden::Test::Helpers
Warden.test_mode!
# Feature: CRUD
feature 'CRUD', :words do
  include_context "word activities"

  before(:each) do
    @user = create(:admin)
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

  scenario 'edit existing word', js: true do
    word = create(:square_meter)
    new_body = "cubic"
    update_word(new_body)
    within_table("words") do
      expect(page).to have_content(new_body)
    end
  end

  scenario 'delete existing possible with im sure' do
    word = create(:square_meter)
    delete_word

    within_table("words") do
      expect(page).not_to have_content(word.body)
    end
  end

  scenario 'impossible to update with empty' do
    word = create(:square_meter)

    update_word('')

    be_on_edit_page
  end

  scenario 'raise not found for not existing id' do

    expect{visit_edit_page_for_not_existing_record}
    .to raise_error( ActionController::RoutingError)
    
  end

  scenario 'raise not found for not existing dictionary' do
    
    expect{visit_words_index_for_not_existing_dictionary}
    .to raise_error( ActionController::RoutingError)
    
  end


  def visit_words_index_for_not_existing_dictionary
    id = 84
    visit dictionary_words_path(dictionary_id: id)
  end

  def visit_edit_page_for_not_existing_record
    id = 999
    visit edit_dictionary_word_path(@dictionary, id: id)
  end

  def be_on_edit_page
    within("h3") do
      expect(page).to have_content("Edit word")
    end
  end

end
