ActiveAdmin.register Comment do

  index do
    selectable_column

    column :id
    column :body
    column :user
    column :created_at

    default_actions
  end

  controller do
    def scoped_collection
      Comment.includes(:user)
    end

    def permitted_params
      params.permit comment: [:name, :url, :kind]
    end
  end
end
