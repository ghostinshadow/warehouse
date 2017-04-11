class Project < ApplicationRecord
  include AASM

  belongs_to :shipping

  before_create :transition_to_built
  before_destroy :reset_project

  aasm do
    state :new, :initial => true
    state :built, :approved, :completed

    event :build do
      transitions from: :new, to: :built
    end

    event :approve do
      transitions from: :built, to: :approved
    end

    event :complete, before: :process_shippings_package do
      transitions from: :approved, to: :completed, guard: :shipping
    end

    event :reset do
      transitions from: :completed, to: :new, guard: :shipping, after: Proc.new {|*args| revert_shippings_package }
      transitions from: :built, to: :new
    end

  end

  def self.all_states
    aasm.states.map(&:name)
  end

  def self.localized_states
    @@localized_states ||= all_states.inject({}){|acc, state| acc[state] = I18n.t("projects.states.#{state}"); acc}
  end

  def prototype_id
    shipping && shipping.prototype_id
  end

  private

  def reset_project
    reset
  end

  def transition_to_built
    build
  end

  def process_shippings_package
    shipping.process_package
  end

  def revert_shippings_package
    shipping.revert_package
  end
end
