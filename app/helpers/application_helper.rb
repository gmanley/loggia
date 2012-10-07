# encoding: UTF-8
module ApplicationHelper
  GRAVATAR_URL_FORMAT = "https://secure.gravatar.com/avatar/%s.png?s=%i&d=mm"

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

  def user_avatar_url(user, size = 16)
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    GRAVATAR_URL_FORMAT % [gravatar_id, size]
  end

  def current_resource
    @current_resource ||= instance_variable_get("@#{controller_name.singularize}")
  end

  def breadcrumb_paths
    return [] unless current_resource
    resources = current_resource.ancestors_and_self.reverse.rotate
    resources.collect {|r| { title: r, url: url_for(r) }}
  end

  def breadcrumbs(elements = [])
    haml_tag 'ul.breadcrumb' do
      breadcrumb('Home', root_path)
      elements.each {|e| breadcrumb(e[:title], e[:url]) }
    end
  end

  private
  def flash_message(type, message)
    haml_tag :div, class: "alert alert-#{bootstrap_flash_class(type)} fade in" do
      haml_tag 'a.close', '×', data: { dismiss: 'alert' }
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
