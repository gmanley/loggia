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

  def breadcrumbs
    return if current_page?(root_path)
    haml_tag 'ul.breadcrumb' do
      breadcrumb('Home', root_path)

      resources.each do |resource|
        breadcrumb(resource.display_name, url_for(resource))
      end
    end
  end

  def link_to_destroy(body, resource, options = {})
    name = (resource.is_a?(Array) ? resource.last : resource).class.name.downcase
    options = {
      method: :delete,
      remote: true,
      confirm: "Are you sure you want to delete this #{name}?"
    }.merge(options)

    link_to(body, resource, options)
  end

  def time_ago(datetime)
    capture_haml do
      haml_tag 'time.timeago', datetime: datetime.iso8601 { datetime }
    end
  end

  private
  def flash_message(type, message)
    haml_tag :div, class: "alert alert-#{bootstrap_flash_class(type)} fade in" do
      haml_tag 'a.close', '×', data: { dismiss: 'alert' }
      haml_concat(message)
    end
  end

  def breadcrumb(text, url = nil)
    if !url or current_page?(url)
      haml_tag 'li.active', text
    else
      haml_tag :li do
        haml_tag :a, text, href: url
        haml_tag 'span.divider', '/'
      end
    end
  end

  def resources # Possibly rename...  specific to breadcrumbs
    return [] unless current_resource
    current_resource.self_and_ancestors.reverse
  end
end
