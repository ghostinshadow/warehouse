class UnitsDictionaryDecorator < Draper::Decorator
  delegate_all
  
  def word_dictionary_path; end

end
