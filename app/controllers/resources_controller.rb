class ResourcesController < ApplicationController
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
      redirect_to resources_path, notice: 'Created successfully'
    else
      render :new
    end
  end

  def edit
  end

  private

  def resource_params
    params.require(:resource).permit(:name_id, :category_id, :unit_id, :type,
                                     :price_uah, :price_usd, :price_eur)
  end

  def set_dictionaries
    @materials_dictionary = MaterialsDictionary.last
    @units_dictionary = UnitsDictionary.last
    @subtype_dictionary = @resource.subcategory_dictionary if @resource
    @subtype_dictionary ||= NoDictionary.new
  end
end
