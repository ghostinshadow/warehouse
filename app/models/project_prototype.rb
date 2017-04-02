class ProjectPrototype < ApplicationRecord
  belongs_to :prototypable, polymorphic: true, foreign_key: 'prototypable_id', optional: true
end
