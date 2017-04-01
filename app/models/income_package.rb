class IncomePackage
  def initialize(shipping_id)
    @shipping_id = shipping_id
  end

  def shipping
    Shipping.find_by(id: @shipping_id)
  end
end