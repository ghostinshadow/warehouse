class DictionariesController < ApplicationController
  def index
    @dictionaries = Dictionary.all
  end

  def edit
  end

  def show
  end
end
