class NoWord
  def body
    I18n.t('n_a')
  end

  def subtype_dictionary
    NoDictionary.new
  end
end