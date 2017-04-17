ActiveAdmin.register Resource do
  menu label: I18n.t('resources.title')

  permit_params :name_id, :category_id, :unit_id, :type, :price_uah, :price_usd, :price_eur

  decorate_with ResourceDecorator

  actions :index, :show, :destroy

  index title: I18n.t('resources.title') do
    selectable_column
    column t('resources.name'),:name do |resource|
      resource.name_body
    end
    column t('resources.category'), :category do |resource|
      resource.category_body
    end

    column t('resources.unit'), :unit do |resource|
      resource.unit_body
    end

    column Resource.price_header(:eur), :price_eur
    column Resource.price_header(:usd), :price_usd
    column Resource.price_header(:uah), :price_uah
    column t('resources.count'), :count
    actions
  end

  show title: I18n.t('resources.title') do
    attributes_table do
      row t('resources.name') do |resource|
        resource.name_body
      end

      row t('resources.category') do |resource|
        resource.category_body
      end
      
      row t('resources.unit') do |resource|
        resource.unit_body
      end

      row Resource.price_header(:eur) do |resource|
        resource.price_eur
      end

      row Resource.price_header(:usd) do |resource|
        resource.price_usd
      end

      row Resource.price_header(:uah) do |resource|
        resource.price_uah
      end

      row t('resources.count') do |resource|
        resource.count
      end

    end
  end

  # filter :usd, label: I18n.t('active_admin.resource.index.usd')
  # filter :eur, label: I18n.t('active_admin.resource.index.eur')
  # filter :valid_on, label: I18n.t('active_admin.resource.index.valid_on')

end
