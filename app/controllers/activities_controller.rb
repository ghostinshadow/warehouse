class ActivitiesController < ApplicationController

  def index
    @activities = ActivityDecorator.decorate_collection(current_user.activities)
  end

end
