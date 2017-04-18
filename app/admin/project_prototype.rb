ActiveAdmin.register ProjectPrototype do
  menu label: I18n.t('project_prototypes.plural')
  decorate_with ProjectPrototypeDecorator

  actions :index, :show


  index title: I18n.t('project_prototypes.plural') do
    selectable_column

    column t('project_prototypes.name'), :name

    column t('project_prototypes.structure'), :structure do |prototype|
      prototype.resources
    end

    column t('project_prototypes.prototypable'), :prototypable do |prototype|
      proto = prototype.prototypable
      proto.decorate.to_s if proto
    end

    actions
  end

  show title: I18n.t('project_prototypes.singular') do
    attributes_table do
      row t('project_prototypes.name') do |prototype|
        prototype.name
      end

      row t('project_prototypes.structure') do |prototype|
        prototype.resources
      end

      row t('project_prototypes.prototypable') do |prototype|
        proto = prototype.prototypable
        proto.decorate.to_s if proto
      end

    end
  end

  filter :name, label: I18n.t('project_prototypes.name')
  
end
