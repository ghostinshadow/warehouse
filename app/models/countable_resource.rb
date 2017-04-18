class CountableResource < Resource
  def <<(num)
    self.count += BigDecimal(num)
  end

  def >>(num)
    self.count -= BigDecimal(num)
  end

  def to_s
    I18n.t('resources.countable')
  end
end