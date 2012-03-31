# encoding: UTF-8
module ApplicationHelper

  BOOTSTRAP_FLASH_CLASS = {
    alert:   'warning',
    notice:  'info',
  }

  def bootstrap_flash_class(type)
    BOOTSTRAP_FLASH_CLASS[type] || type.to_s
  end

  def flash_messages
    flash.each do |type, message|
      flash_message(type, message) if message.is_a?(String)
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
  def flash_message(type, message)
    haml_tag :div, class: "alert alert-#{bootstrap_flash_class(type)} fade in" do
      haml_tag 'a.close', '×', data: {dismiss: 'alert'}
      haml_concat(message)
    end
  end


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
