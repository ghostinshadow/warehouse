class Resource < ApplicationRecord
  belongs_to :name, class_name: "Word", foreign_key: :name_id
  belongs_to :category, class_name: "Word", foreign_key: :category_id, optional: true
  belongs_to :unit, class_name: "Word", foreign_key: :unit_id

  def self.available_resources
    [["Countable", "CountableResource"],["Countless", "CountlessResource"]]
  end

  def to_partial_path
    'resources/resource'
  end

  def category_dictionary
    name.subtype_dictionary
  end
end
