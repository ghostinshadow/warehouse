class WordsController < ApplicationController
  before_action :set_word, only: [:edit, :update, :delete]
  
  def index
    @words = Word.all
  end

  def new
    @word = Word.new
  end

  def create
    @word = Word.create(word_params)
    if @word.save
      redirect_to words_path
    else
      flash[:error] = @word.errors.messages.to_s
      render :new
    end
  end

  def edit
  end

  def update
    if @word.update_attributes(word_params)
      redirect_to words_path, notice: "Successfully updated"
    else
      flash[:error] = @word.errors.messages.to_s
      render :edit
    end
  end

  private

  def set_word
    @word = Word.find_by(id: params[:id])
    raise ActionController::RoutingError.new('Not Found') unless @word
  end

  def word_params
    params.require(:word).permit(:body)
  end
end
