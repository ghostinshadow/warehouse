class CountableResource < Resource
  def <<(num)
    self.count += BigDecimal(num)
  end

  def >>(num)
    self.count -= BigDecimal(num)
  end
end