class ProjectsController < ApplicationController
  authorize_resource
  
  before_action :set_project, only: [:show, :destroy, :update]
  decorates_assigned :project

  def index
    @projects = ProjectDecorator.decorate_collection(Project.all)
  end

  def new
    @shipping = Shipping.new
    @existing_prototypes = ProjectPrototype.prototypes_options
  end

  def show
    @money_calculator = MoneyCalculator.new({project_prototype_id: @project.prototype_id})
  end

  def update
    @project.approve
    @project.complete
    @project.save
    track_activity(@project)
    # redirect_to project_path(@project), notice: "Approved"
    redirect_to :back, notice: t('controller.actions.approved')
  end

  def create
    build_project
    if @project.save
      track_activity(@project)
      redirect_to projects_path, notice: t('controller.actions.created')
    else
      flash[:error] = @project.errors.messages.to_s
      render :new
    end
  end

  def destroy
    track_activity(@project)
  	@project.destroy
  	redirect_to projects_path, notice: t('controller.actions.deleted')
  end

  private

  def set_project
    @project = Project.find_by(id: params[:id])
    raise ActionController::RoutingError.new(t('controller.actions.not_found')) unless @project
  end

  def build_project
    prototype_params = init_and_validate_params

    @project = Project.new  do |p|
      p.shipping = Shipping.new(shipping_params) do |s|
        s.project_prototype = init_or_find_prototype(prototype_params)
      end
    end
  end

  def init_and_validate_params
  	return {} if params[:existing_prototype]
    project_params = ProjectParameters.new(project_prototype_params)
    project_params.valid?
    project_params
  end

  def init_or_find_prototype(project_params)
    return ProjectPrototype.find_by(id: params[:existing_prototype]) if params[:existing_prototype]
    ProjectPrototype.new(project_params.to_attributes)
  end

  def project_prototype_params
  	return params unless params[:project_prototype]
    params.require(:project_prototype).to_unsafe_h 
  end

  def shipping_params
    params.require(:shipping).permit(:shipping_date).merge(package_variant: "OutcomePackage")
  end
end
