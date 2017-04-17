ActiveAdmin.register User do
  menu label: I18n.t('users.plural')
  permit_params :email, :password, :password_confirmation

  member_action :approve, method: :put do
    resource.approve!
    redirect_to resource_path, notice: "Approved!"
  end

  controller do
    def scoped_collection
      end_of_association_chain.where.not(role: "admin")
    end
  end

  index title: I18n.t('users.singular') do
    selectable_column
    id_column
    column t('users.email'), :email
    column t('users.name'), :name
    column t('users.role'), :role

    actions do |user|
      link_to t('users.actions.approve'),  approve_admin_user_path(user) if user.guest?
    end
  end

  show title: I18n.t('users.name') do
    attributes_table do
      row t('users.name') do |user|
        user.name
      end

      row t('users.email') do |user|
        user.email
      end
      
      row t('users.role') do |user|
        user.role
      end
    end
  end

  filter :email, label: I18n.t('users.email')
  filter :name, label: I18n.t('users.name')
  filter :role, label: I18n.t('users.role')

  form do |f|
    f.inputs "Admin Details" do
      f.input :email, label: "Java"
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
