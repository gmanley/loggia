module CategoryHelper

  def breadcrumb_paths
    @category.ancestors_and_self.collect do |e|
      {title: e.title, url: url_for(e)}
    end
  end
end
