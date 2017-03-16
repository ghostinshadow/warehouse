class Word < ApplicationRecord
  validates_presence_of :body
  belongs_to :dictionary, counter_cache: true
  
  has_one :subtype_dictionary, class_name: "Dictionary", dependent: :destroy
  after_commit :init_subtype_dictionary, if: -> { dictionary.subtypes_allowed?}

  private

  def init_subtype_dictionary
    title = "#{self.body}: #{I18n.t("company.dictionaries.resources.category_subtypes")}"
    self.create_subtype_dictionary(title: title,
                                                 type: "CategorySubtypes")
  end
end
