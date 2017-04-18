ActiveAdmin.register Project do
  menu label: I18n.t('projects.plural')

  decorate_with ProjectDecorator

  actions :index, :show, :destroy

  index title: I18n.t('projects.plural') do
    selectable_column

    column t('projects.status'), :status

    column t('projects.shipping_date'), :shipping_date

    column t('projects.prototype_name'), :prototype_name

    actions do |project|
      unless project.completed? || project.approved?
        link_to t('projects.actions.approve'),  project_path(project), method: :put
      end
    end
  end

  show title: I18n.t('projects.singular') do
    attributes_table do
      row t('projects.status') do |project|
        project.status
      end

      row t('projects.shipping_date') do |project|
        project.shipping_date
      end

      row t('project_prototypes.singular') do |project|
        if project.shipping
          link_to t('show'),  admin_shipping_path(id: project.shipping.id)
        end
      end
    end
  end

  filter :aasm_state, label: I18n.t('projects.status'), as: :select,
    collection: [['Збережений','built'], ['Підтверджений','approved'], ['Готовий', 'completed']]

end
