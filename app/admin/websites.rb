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
      f.input :name
      f.input :url
      f.input :kind, as: :select, collection: Source::POSSIBLE_KINDS, include_blank: false
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

  controller do
    def scoped_collection
      Source.websites
    end
  end
end
