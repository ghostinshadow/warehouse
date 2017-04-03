class DailyCurrency < ApplicationRecord
  validates_presence_of :usd, :eur, :valid_on
end
