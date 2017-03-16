class Word < ApplicationRecord
  validates_presence_of :body
  belongs_to :dictionary, counter_cache: true
end
