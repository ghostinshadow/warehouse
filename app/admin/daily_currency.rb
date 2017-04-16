ActiveAdmin.register DailyCurrency do
  permit_params :usd, :eur, :valid_on
  decorate_with DailyCurrencyDecorator

  index do
    selectable_column
    column t('.usd'),:usd do |daily_currency|
      daily_currency.display_usd
    end

    column t('.eur'), :eur do |daily_currency|
      daily_currency.display_eur
    end

    column t('.valid_on'), :valid_on

  end

  filter :usd, label: I18n.t('active_admin.resource.index.usd')
  filter :eur, label: I18n.t('active_admin.resource.index.eur')
  filter :valid_on, label: I18n.t('active_admin.resource.index.valid_on')

end
