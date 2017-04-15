ActiveAdmin.register User do
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

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions do |user|
      link_to 'Approve user',  approve_admin_user_path(user) if user.guest?
    end
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
