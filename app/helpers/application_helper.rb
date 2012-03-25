# encoding: UTF-8
module ApplicationHelper

  def flash_messages
    flash.select{|name, msg| msg.is_a?(String)}.each do |name, msg|
      haml_tag :div, class: "alert #{name} fade in", data: {alert: 'alert'} do
        haml_tag 'a.close', '×', data: {dismiss: 'alert'}
        haml_concat(msg)
      end
    end
  end

  def breadcrumb_paths
    current_resource = instance_variable_get("@#{controller_name.singularize}") || []
    current_resource.ancestors_and_self.collect do |e|
      {title: e.title, url: url_for(e)}
    end
  end

  def breadcrumbs(elements = [])
    haml_tag 'ul.breadcrumb' do
      breadcrumb('Home', root_path)
      elements.each do |element|
        breadcrumb(element[:title], element[:url])
      end
    end
  end

  private
  def breadcrumb(text, link = nil)
    if link
      haml_tag :li do
        haml_tag :a, text, href: link
        haml_tag 'span.divider', '/'
      end
    else
      haml_tag 'li.active', text
    end
  end
end
