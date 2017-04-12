class ProjectPrototypesController < ApplicationController
  authorize_resource

  def show
    @prototype = ProjectPrototype.find_by(id: params[:id])
    @money_calculator = MoneyCalculator.new({project_prototype_id: @prototype.id}) if @prototype
    @prototype = @prototype.decorate if @prototype
  end
end
