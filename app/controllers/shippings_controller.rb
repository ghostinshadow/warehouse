class ShippingsController < ApplicationController
  authorize_resource
  
  before_action :set_shipping, only: [:show, :destroy]
  decorates_assigned :shipping

  def index
    collection = Shipping.all.desc_order.page(params[:page])
    @shippings = ShippingDecorator.decorate_collection(collection)
  end

  def show
    @money_calculator = MoneyCalculator.new({project_prototype_id: @shipping.prototype_id})
  end

  def new
    @shipping = Shipping.new do |s|
      s.project_prototype = ProjectPrototype.new
    end
  end

  def create
    project_params = ProjectParameters.new(project_prototype_params)
    project_params.valid?

    @shipping = Shipping.new(shipping_params) do |s|
      s.project_prototype = ProjectPrototype.new(project_params.to_attributes)
    end
    
    if @shipping.save
      @shipping.process_package
      track_activity(@shipping)
      redirect_to shippings_path, notice: t('controller.actions.created')
    else
      flash[:error] = @shipping.errors.messages.to_s
      render :new
    end
  end

  def destroy
    @shipping.revert_package
    @shipping.destroy
    track_activity(@shipping)
    redirect_to shippings_path, notice: t('controller.actions.deleted')
  end

  private

  def set_shipping
    @shipping = Shipping.find_by(id: params[:id])
    raise ActionController::RoutingError.new(t('controller.actions.not_found')) unless @shipping
  end

  def shipping_params
    params.require(:shipping).permit(:package_variant, :shipping_date)
  end

  def project_prototype_params
    params.require(:project_prototype).to_unsafe_h
  end

end
