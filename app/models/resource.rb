class Resource < ApplicationRecord
  belongs_to :name, class_name: "Word", foreign_key: :name_id
  belongs_to :category, class_name: "Word", foreign_key: :category_id, optional: true
  belongs_to :unit, class_name: "Word", foreign_key: :unit_id
  validates_inclusion_of :type, in: %w{ CountlessResource  CountableResource}
  validates_presence_of :name_id, :unit_id

  def self.available_resources
    [[I18n.t('resources.countable'), "CountableResource"],[I18n.t('resources.countless'), "CountlessResource"]]
  end

  def self.price_header(currency)
    locale = I18n.t("resources.price_#{currency}")
    "#{locale} (#{DailyCurrency.currency_symbols[currency]})"
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
