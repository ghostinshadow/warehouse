class ResourcesController < ApplicationController
  authorize_resource
  
  before_action :set_resource, only: [:edit, :update, :destroy]
  before_action :set_dictionaries, only: [:new, :edit, :create, :update]

  def index
    @resources = Resource.all
  end

  def new
    @resource = Resource.new
  end

  def create
    @resource = Resource.new(resource_params)
    if @resource.save
      track_activity(@resource)
      redirect_to resources_path, notice: 'Created successfully'
    else
      flash[:error] = @resource.errors.messages.to_s
      render :new
    end
  end

  def edit
  end

  def update
    if @resource.update_attributes(resource_params)
      track_activity(@resource)
      redirect_to resources_path, notice: 'Updated successfully'
    else
      flash[:error] = @resource.errors.messages.to_s
      render :edit
    end
  end

  def destroy
    @resource.destroy
    track_activity(@resource)
    redirect_to resources_path, notice: 'Destroyed successfully'
  end

  private

  def set_flash_errors
    flash[:error] = @resource.errors.messages.to_s
  end

  def set_resource
    @resource = Resource.find_by(id: params[:id])
    raise ActionController::RoutingError.new('Not Found') unless @resource
  end

  def resource_params
    params.require(:resource).permit(:name_id, :category_id, :unit_id, :type,
                                     :price_uah, :price_usd, :price_eur)
  end

  def update_params
    resource_params.except(:type)
  end

  def set_dictionaries
    @materials_dictionary = MaterialsDictionary.last
    @units_dictionary = UnitsDictionary.last
    @subtype_dictionary = @resource.category_dictionary if @resource
    @subtype_dictionary ||= NoDictionary.new
  end
end
