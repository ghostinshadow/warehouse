class MaterialsDictionaryDecorator < Draper::Decorator
  delegate_all

  def word_dictionary_path
    h.link_to("Back to dictionaries", h.dictionaries_path, class: "btn btn-danger")
  end

end
