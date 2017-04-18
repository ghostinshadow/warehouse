class IncomePackage
  def initialize(shipping_id)
    @shipping_id = shipping_id
  end

  def shipping
    Shipping.find_by(id: @shipping_id)
  end

  def project_prototype
    ProjectPrototype.find_by(prototypable_type: "Shipping", prototypable_id: @shipping_id)
  end

  def type_name
    "прихід"
  end

  def outcome?
    false
  end

  def income?
    true
  end

  def process_package
    project_prototype.structure.each do |resource_id, resource_num|
      r = Resource.find_by(id: resource_id)
      r << resource_num
      r.save
    end
  end

  def revert_package
    project_prototype.structure.each do |resource_id, resource_num|
      r = Resource.find_by(id: resource_id)
      r >> resource_num
      r.save
    end
  end
end