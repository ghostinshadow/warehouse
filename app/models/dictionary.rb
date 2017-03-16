class Dictionary < ApplicationRecord
  has_many :words
  belongs_to :word, optional: true
  validates_presence_of :title, :type

  def to_partial_path
    'dictionaries/dictionary'
  end

  def subtypes_allowed?
    false
  end
end
