class Dictionary < ApplicationRecord
  has_many :words

  def to_partial_path
    'dictionaries/dictionary'
  end
end
