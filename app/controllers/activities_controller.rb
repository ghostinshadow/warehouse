class ActivitiesController < ApplicationController
  authorize_resource

  def index
    activities_collection = current_user.activities.order(created_at: :desc).page(params[:page])
    @activities = ActivityDecorator.decorate_collection(activities_collection)
  end

end
