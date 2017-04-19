class WelcomeController < ApplicationController
  def index
    unless current_user.guest?
      redirect_to resources_path
    end
  end
end
