class StructureElementsController < ApplicationController
  def new
    @id = params[:association_id]
    @param_name = "project_prototype[structure]"
    @resources =  CountableResource.all.includes(:name).options
  end
end
