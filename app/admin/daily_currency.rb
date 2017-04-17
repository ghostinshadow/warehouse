ActiveAdmin.register DailyCurrency do
  menu label: I18n.t('daily_currencies.title')
  permit_params :usd, :eur, :valid_on
  decorate_with DailyCurrencyDecorator

  actions :index, :show, :destroy

  index title: I18n.t('daily_currencies.title') do
    selectable_column
    column t('.usd'),:usd do |daily_currency|
      daily_currency.display_usd
    end

    column t('.eur'), :eur do |daily_currency|
      daily_currency.display_eur
    end

    column t('.valid_on'), :valid_on
    actions
  end

  show title: I18n.t('daily_currencies.title') do
    attributes_table do
      row t('daily_currencies.usd') do |currency|
        currency.display_usd
      end

      row t('daily_currencies.eur') do |currency|
        currency.display_eur
      end
      
      row t('daily_currencies.valid_on') do |currency|
        currency.valid_on
      end

    end
  end

  filter :usd, label: I18n.t('active_admin.resource.index.usd')
  filter :eur, label: I18n.t('active_admin.resource.index.eur')
  filter :valid_on, label: I18n.t('active_admin.resource.index.valid_on')

end
