class DailyCurrencyDecorator < Draper::Decorator
  delegate_all

  def display_usd
    h.number_to_currency usd, unit: DailyCurrency.currency_symbols[:uah]
  end

  def display_eur
    h.number_to_currency eur, unit: DailyCurrency.currency_symbols[:uah]
  end

end
