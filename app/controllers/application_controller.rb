class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def track_activity(trackable, action = params[:action])
    current_user.activities.create!(action: action, trackable: trackable)
  end
end