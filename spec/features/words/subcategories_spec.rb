require "rails_helper"
include Warden::Test::Helpers
Warden.test_mode!
# Feature: CRUD
feature 'CRUD', :subcategories do

  before(:each) do
    @user = create(:admin)
    login_as(@user, scope: :user)
    @dictionary = create(:materials_dictionary)
  end

  after(:each) do
    Warden.test_reset!
  end

  scenario "MaterialsDictionary word has subcategory words", js: true do
    dictionary = @dictionary.becomes(MaterialsDictionary)
    word = dictionary.words.create(body: "m2")

    go_to_subcategories(dictionary)
    header_is_a("Words")
  end

  scenario "go back to words from subcategories", js: true do
    dictionary = @dictionary.becomes(MaterialsDictionary)
    dictionary = dictionary.decorate
    word = dictionary.words.create(body: "m2")
    go_to_subcategories(dictionary)

    click_link "Back to materials"

    header_is_a("Words")
  end

  scenario "UnitDictionary word has no subcategory words", js: true do
    dictionary = @dictionary.becomes(UnitsDictionary)
    word = dictionary.words.create(body: "m2")

    visit dictionary_words_path(dictionary)
    
    expect(find(:xpath, '//table/tbody/tr[2]').text).not_to match("Subcategories")
  end

  def go_to_subcategories(dictionary)
    visit dictionary_words_path(dictionary)
    first(:link, "Subcategories").click
  end

  def header_is_a(word)
    within("h3") do
      expect(page).to have_content(word)
    end
  end
end
