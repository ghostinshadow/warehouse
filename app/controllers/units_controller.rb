class UnitsController < ApplicationController
  def index
    @units = Unit.all
  end

  def new
    @unit = Unit.new
  end

  def create
    @unit = Unit.create(unit_params)
    redirect_to units_path
  end

  private

  def unit_params
    params.require(:unit).permit(:name)
  end
end
