ActiveAdmin.register Dictionary do
  menu label: I18n.t('dictionaries.plural')

  permit_params :type, :title, :words_count, :word_id

  actions :index, :show

  index title: I18n.t('dictionaries.plural') do
    selectable_column

    column t('dictionaries.title'), :category do |dictionary|
      dictionary.title
    end

    column t('dictionaries.words_count'), :words_count

    column t('dictionaries.word'), :word_id do |dictionary|
      word = dictionary.word || NoWord.new
      word.body
    end

    actions
  end

  show title: I18n.t('dictionaries.singular') do
    attributes_table do
      row t('dictionaries.title') do |dictionary|
        dictionary.title
      end

      row t('dictionaries.words_count') do |dictionary|
        dictionary.words_count
      end

      row t('dictionaries.word') do |dictionary|
        word = dictionary.word || NoWord.new
        word.body
      end

    end
  end

  filter :words_count, label: I18n.t('dictionaries.words_count')
  filter :title, label: I18n.t('dictionaries.title')
  filter :word, label: I18n.t('dictionaries.word'), as: :select, collection: proc {
    dictionary = MaterialsDictionary.last
    dictionary.options
  }

end
