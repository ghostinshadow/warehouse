class MaterialsDictionaryDecorator < Draper::Decorator
  delegate_all

  def word_dictionary_path
    h.link_to(I18n.t('words.back_to_dictionaries'), h.dictionaries_path, class: "btn btn-danger")
  end

end
