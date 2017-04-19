class DailyCurrenciesController < ApplicationController
  authorize_resource
  
  before_action :set_daily_currency, only: [:edit, :update, :destroy]

  def index
    @daily_currencies = DailyCurrency.all
  end

  def new
    @daily_currency = DailyCurrency.new
  end

  def create
    @daily_currency = DailyCurrency.new(daily_currency_params)
    if @daily_currency.save
      redirect_to daily_currencies_path, notice: t('controller.actions.created')
    else
      flash[:error] = @daily_currency.errors.messages.to_s
      render :new
    end
  end

  def edit
  end

  def update
    if @daily_currency.update_attributes(daily_currency_params)
      redirect_to daily_currencies_path, notice: t('controller.actions.update')
    else
      flash[:error] = @daily_currency.errors.messages.to_s
      render :edit
    end
  end

  def destroy
    @daily_currency.destroy
    redirect_to daily_currencies_path, notice: t('controller.actions.deleted')
  end

  private

  def set_daily_currency
    @daily_currency = DailyCurrency.find_by(id: params[:id])
    raise ActionController::RoutingError.new(t('controller.actions.not_found')) unless @daily_currency
  end

  def daily_currency_params
    params.require(:daily_currency).permit(:usd, :eur, :valid_on)
  end
end
