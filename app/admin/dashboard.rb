ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do

    columns do
      column do
        panel 'Recent Comments', id: 'comments' do
          ol id: 'comments-list' do
            render Comment.includes(:commentable, :user).order(:updated_at).limit(10)
          end
        end
      end
    end
  end
end
