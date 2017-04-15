ActiveAdmin.register DailyCurrency do
  permit_params :usd, :eur, :valid_on
  decorate_with DailyCurrencyDecorator

  index do
    selectable_column
    column :usd do |daily_currency|
      daily_currency.display_usd
    end

    column :eur do |daily_currency|
      daily_currency.display_eur
    end

    column :valid_on

  end

end
