class DictionariesController < ApplicationController
  authorize_resource
  before_action :set_dictionary, only: [:edit, :show, :update]
  
  def index
    @dictionaries = Dictionary.all.high_level
  end

  def update
    if @dictionary.update_attributes(dictionary_params)
      track_activity(@dictionary)
      redirect_to dictionaries_path, notice: t('controller.actions.updated')
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
    raise ActionController::RoutingError.new(t('controller.actions.not_found')) unless @dictionary
  end
end
