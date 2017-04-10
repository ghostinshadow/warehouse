class Project < ApplicationRecord
  include AASM

  belongs_to :shipping

  after_create :transition_to_built
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

    event :reset, after: :revert_shippings_package do
      transitions from: :completed, to: :new, guard: :shipping
    end

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
