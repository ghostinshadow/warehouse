class CategorySubtypesDecorator < Draper::Decorator
  delegate_all

  def word_dictionary_path
    h.link_to(I18n.t('words.back_to_materials'), h.dictionary_words_path(word.dictionary), class: "btn btn-danger")
  end

end
