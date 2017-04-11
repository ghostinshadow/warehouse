class ProjectPrototype < ApplicationRecord
  belongs_to :prototypable, polymorphic: true, foreign_key: 'prototypable_id', optional: true

  def self.prototypes_options
    includes(:prototypable).lazy
    .select{|proto| proto.prototypable_outcome?}
    .map{|e| [e.full_name, e.id]}
    .to_a
  end

  def prototypable_outcome?
    return false unless prototypable
    prototypable.outcome_package?
  end

  def full_name
    "#{name} - #{prototypable.shipping_date}"
  end

  def each
    structure.each do |k, v|
      resource = Resource.find_by(id: k)
      yield resource, v if block_given?
    end
  end

end
