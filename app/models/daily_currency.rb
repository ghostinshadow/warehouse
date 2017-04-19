class DailyCurrency < ApplicationRecord
  validates_presence_of :usd, :eur, :valid_on
    paginates_per 10

  scope :desc_order, -> { order(created_at: :desc) }

  def self.currency_symbols
    {uah: '₴', usd: '$', eur: "€"}
  end
end
