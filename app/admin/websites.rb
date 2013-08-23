ActiveAdmin.register Source, as: 'Website' do
  config.sort_order = 'name_asc'

  filter :id
  filter :name
  filter :url

  index do
    selectable_column

    column :id
    column :name
    column :url

    actions do |source|
      link_to 'Images', source, class: 'member_link'
    end
  end

  form do |f|
    f.inputs do
      f.input :name, as: :string
      f.input :url
    end

    f.actions
  end

  batch_action :merge, confirm: 'Are you sure you wish to consolidate these sources into one?' do |selection|
    if Source.merge!(selection)
      redirect_to :back, notice: 'Sources merged'
    else
      redirect_to :back, alert: 'Unable to merge sources'
    end
  end

  show do
    attributes_table :name, :url, :created_at, :updated_at
  end

  controller do
    def scoped_collection
      Source.websites
    end

    def permitted_params
      params.permit website: [:name, :url]
    end
  end
end
