class Resource < ApplicationRecord
  belongs_to :name, class_name: "Word", foreign_key: :name_id
  belongs_to :category, class_name: "Word", foreign_key: :category_id, optional: true
  belongs_to :unit, class_name: "Word", foreign_key: :unit_id
  validates_inclusion_of :type, in: %w{ CountlessResource  CountableResource}

  def self.available_resources
    [["Countable", "CountableResource"],["Countless", "CountlessResource"]]
  end

  def self.options
    all.map{|r| [r.name_body, r.id]}
  end

  def name_body
    name.body
  end

  def to_partial_path
    'resources/resource'
  end

  def category_dictionary
    name.subtype_dictionary
  end
end
