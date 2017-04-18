ActiveAdmin.register Shipping do
  menu label: I18n.t('shippings.plural')

  controller do
    def destroy
      resource.revert_package
      resource.destroy
      track_activity(resource)
      redirect_to resources_path, notice: "Destroyed successfully"
    end
  end

  decorate_with ShippingDecorator

  actions :index, :show, :destroy

  index title: I18n.t('shippings.plural') do
    selectable_column

    column t('shippings.package'), :package

    column t('shippings.shipping_date'), :shipping_date

    actions
  end

  show title: I18n.t('shippings.singular') do
    attributes_table do
      row t('shippings.package') do |shipping|
        shipping.package
      end

      row t('shippings.shipping_date') do |shipping|
        shipping.shipping_date
      end

      row t('project_prototypes.singular') do |shipping|
        if shipping.project_prototype
          link_to t('show'),  admin_project_prototype_path(id: shipping.project_prototype.id)
        end
      end
    end
  end

  # filter :prototypable_id, label: I18n.t('shippings.prototypable')
  filter :shipping_date, label: I18n.t('shippings.shipping_date')
  filter :package_variant, label: I18n.t('shippings.package'), as: :select,
    collection: [['прихід', "IncomePackage"], ['розхід', "OutcomePackage"]]

end
