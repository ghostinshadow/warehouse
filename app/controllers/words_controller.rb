class WordsController < ApplicationController
  before_action :set_word, only: [:edit, :update, :destroy]
  before_action :set_dictionary
  decorates_assigned :dictionary
  
  def index
    @words = @dictionary.words
  end

  def new
    @word = Word.new
  end

  def create
    @word = @dictionary.words.create(word_params)
    if @word.save
      redirect_to dictionary_words_path(@dictionary)
    else
      flash[:error] = @word.errors.messages.to_s
      render :new
    end
  end

  def edit
  end

  def update
    if @word.update_attributes(word_params)
      redirect_to dictionary_words_path(@dictionary), notice: "Successfully updated"
    else
      flash[:error] = @word.errors.messages.to_s
      render :edit
    end
  end

  def destroy
    @word.destroy
    redirect_to dictionary_words_path(@dictionary), notice: "Successfully deleted"
  end

  def subtypes
    word = Word.find_by(id: params[:id]) || NoWord.new
    @subtype_dictionary = word.subtype_dictionary
  end

  private

  def set_dictionary
    @dictionary = Dictionary.find_by(id: params[:dictionary_id])
    raise ActionController::RoutingError.new('Not Found') unless @dictionary
  end

  def set_word
    @word = Word.find_by(id: params[:id])
    raise ActionController::RoutingError.new('Not Found') unless @word
  end

  def word_params
    params.require(:word).permit(:body)
  end
end
