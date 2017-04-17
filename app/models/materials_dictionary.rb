class MaterialsDictionary < Dictionary
  def subtypes_allowed?
    true
  end

  def to_human
    I18n.t('dictionaries.materials_dictionary')
  end
end