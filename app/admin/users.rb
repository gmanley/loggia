ActiveAdmin.register User do
  actions :show, :index

  filter :id
  filter :email
  filter :sign_in_count
  filter :last_sign_in_at
  filter :last_sign_in_ip

  index do
    column :id
    column :email
    column :sign_in_count
    column :last_sign_in_at
    column :last_sign_in_ip
    column :admin
    column :created_at

    default_actions
  end
end
