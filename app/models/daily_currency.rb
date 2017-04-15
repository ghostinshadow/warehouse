class DailyCurrency < ApplicationRecord
  validates_presence_of :usd, :eur, :valid_on

  def self.currency_symbols
    {uah: '₴', usd: '$', eur: "€"}
  end
end
