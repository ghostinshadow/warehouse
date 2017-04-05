class ShippingDecorator < Draper::Decorator
  delegate_all
  decorates_association :project_prototype

  def shipping_date
    super.strftime("%d/%m/%Y")
  end

  def package
    super.type_name.upcase
  end

  [:structure, :name, :resources].each do |attribute|
    define_method("project_#{attribute}") do
      prototype = project_prototype || NoProjectPrototype.new
      prototype.public_send(attribute)
    end
  end

end
