class Shipping < ApplicationRecord
  AVAILABLE_TYPES = %w{ IncomePackage  OutcomePackage }.freeze

  has_one :project_prototype, as: :prototypable, dependent: :destroy
  validates_inclusion_of :package_variant, in: AVAILABLE_TYPES

  validates_presence_of :shipping_date
  
  accepts_nested_attributes_for :project_prototype

  delegate :process_package, :reverse_package, to: :package
  
  def package
    return NoPackage.new unless persisted? && package_variant?
    @package ||= package_variant.constantize.new(id)
    @package
  end
end