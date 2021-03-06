class Shipping < ApplicationRecord
  AVAILABLE_TYPES = %w{ IncomePackage  OutcomePackage }.freeze

  has_one :project_prototype, as: :prototypable, dependent: :destroy
  has_one :project, dependent: :destroy
  validates_inclusion_of :package_variant, in: AVAILABLE_TYPES

  validates_presence_of :shipping_date

  accepts_nested_attributes_for :project_prototype

  delegate :process_package, :revert_package, :type_name, to: :package
  paginates_per 10

  scope :desc_order, -> { order(created_at: :desc) }


  def self.package_options
    [[I18n.t('resources.income'), I18n.t('resources.outcome')], AVAILABLE_TYPES].transpose
  end

  def package
    return NoPackage.new unless persisted? && package_variant?
    @package ||= package_variant.constantize.new(id)
    @package
  end

  def outcome_package?
    package.outcome?
  end

  def prototype_id
    project_prototype.id
  end

end
