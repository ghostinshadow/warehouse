class ShippingsController < ApplicationController
  def index
    @shippings = Shipping.all
  end

  def new
    @shipping = Shipping.new do |s|
      s.project_prototype = ProjectPrototype.new
    end
  end

  def create
    ProjectParameters.new(project_prototype_params)
    @shipping = Shipping.new(shipping_params) do |s|
      s.project_prototype = ProjectPrototype.new(project_prototype_params)
    end
    if @shipping.save
      @shipping
      redirect_to shippings_path, notice: "Shipping created"
    else
      flash[:error] = @shipping.errors.messages.to_s
      render :new
    end
  end

  def edit
  end

  private

  def shipping_params
    params.require(:shipping).permit(:package_variant, :shipping_date)
  end

  def project_prototype_params
    params.require(:project_prototype)
  end

end
