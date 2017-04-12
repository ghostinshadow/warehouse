class ActivitiesController < ApplicationController
  authorize_resource

  def index
    @activities = ActivityDecorator.decorate_collection(current_user.activities)
  end

end
