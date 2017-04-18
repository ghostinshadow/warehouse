class CountlessResource < Resource
  def <<(num); end

  def >>(num); end

  def to_s
    I18n.t('resources.countless')
  end
end