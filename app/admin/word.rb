ActiveAdmin.register Word do
  menu label: I18n.t('words.plural')
  permit_params :usd, :eur, :valid_on

  actions :index, :show, :destroy

  "body"
  "dictionary_id"

  index title: I18n.t('words.plural') do
    selectable_column

    column t('words.dictionary'), :dictionary_id do |word|
      dictionary = word.dictionary || NoDictionary.new
      dictionary.title
    end

    column t('words.body'), :body


    actions
  end

  show title: I18n.t('words.singular') do
    attributes_table do
      row t('words.dictionary') do |word|
        dictionary = word.dictionary || NoDictionary.new
        dictionary.title
      end

      row t('words.body') do |word|
        word.body
      end

    end
  end

  filter :body, label: I18n.t('words.body')
  filter :dictionary, label: I18n.t('words.dictionary'), as: :select, collection: proc{
    Dictionary.all.pluck(:title, :id)
  }
  
end
