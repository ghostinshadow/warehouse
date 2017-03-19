class DictionariesController < ApplicationController
  before_action :set_dictionary, only: [:edit, :show, :update]
  def index
    @dictionaries = Dictionary.all.high_level
  end

  def update
    if @dictionary.update_attributes(dictionary_params)
      redirect_to dictionaries_path, notice: "Successfully updated"
    else
      flash[:error] = @dictionary.errors.messages.to_s
      render :edit
    end
  end

  def edit
  end

  def show
  end

  private

  def dictionary_params
    params.require(:dictionary).permit(:title)
  end

  def set_dictionary
    @dictionary = Dictionary.find_by(id: params[:id])
    raise ActionController::RoutingError.new("Not Found") unless @dictionary
  end
end
