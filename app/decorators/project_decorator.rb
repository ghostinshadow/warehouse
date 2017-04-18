class ProjectDecorator < Draper::Decorator
  delegate_all
  decorates_association :shipping

  def status
    Project.localized_states[aasm_state.to_sym]
  end

  def shipping_date
    shipping.shipping_date if shipping
  end

  def prototype_name
    shipping.project_name
  end

  def to_s
    "Проект #{prototype_name} - #{shipping_date}"
  end

  def self.collection_decorator_class
    PaginatingDecorator
  end
end
