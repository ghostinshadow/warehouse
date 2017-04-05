class ProjectPrototype < ApplicationRecord
  belongs_to :prototypable, polymorphic: true, foreign_key: 'prototypable_id', optional: true

  def each
    structure.each do |k, v|
      resource = Resource.find_by(id: k)
      yield resource, v if block_given?
    end
  end
end
