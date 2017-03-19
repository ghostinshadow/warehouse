class Dictionary < ApplicationRecord
  has_many :words
  belongs_to :word, optional: true
  validates_presence_of :title, :type
  scope :high_level, -> { where.not(type: "CategorySubtypes") }

  def to_partial_path
    'dictionaries/dictionary'
  end

  def subtypes_allowed?
    false
  end
end
