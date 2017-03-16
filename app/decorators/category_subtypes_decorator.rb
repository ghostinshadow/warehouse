class CategorySubtypesDecorator < Draper::Decorator
  delegate_all

  def word_dictionary_path; end

end
