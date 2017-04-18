ActiveAdmin.register Activity do
  menu label: I18n.t('activities.plural')

  actions :index

  index title: I18n.t('activities.plural') do
    selectable_column
    column t('activities.user'),:user_id do |activity|
      activity.user
    end

    column t('activities.action'), :action do |activity|
      activity.action
    end

    column t('activities.trackable'), :trackable_type

    actions
  end

  filter :user, label: I18n.t('activities.user')
  filter :action, label: I18n.t('activities.action')
  filter :trackable_type, label: I18n.t('activities.trackable')

end
