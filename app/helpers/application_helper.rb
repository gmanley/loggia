# encoding: UTF-8
module ApplicationHelper
  BREADCRUMB_MICRODATA_URL = 'http://data-vocabulary.org/Breadcrumb'

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
        breadcrumb(resource.to_s, url_for(resource))
      end
    end
  end

  def link_to_destroy(body, resource, options = {})
    name = resource.class.name.downcase
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

  # Make the default kaminari theme bootstrap unless we are in the admin panel
  def paginate(scope, options = {}, &block)
    unless respond_to?(:active_admin_application)
      options[:theme] ||= 'bootstrap'
    end

    super
  end

  private
  def flash_message(type, message)
    haml_tag :div, class: "alert alert-#{bootstrap_flash_class(type)} fade in" do
      haml_tag 'a.close', '×', data: { dismiss: 'alert' }
      haml_concat(message)
    end
  end

  def breadcrumb(text, url = nil)
    attrs = { itemscope: true, itemtype: BREADCRUMB_MICRODATA_URL }
    attrs.merge!(class: 'active') if current_page?(url)

    haml_tag :li, attrs do
      haml_tag :a, href: url, itemprop: 'url' do
        haml_tag :span, text, itemprop: 'title'
      end

      haml_tag 'span.divider', '/' unless current_page?(url)
    end
  end

  def resources # Possibly rename...  specific to breadcrumbs
    return [] unless current_resource
    if current_resource.is_a?(Album)
      current_resource.self_and_ancestors.reverse
    else
      Array(current_resource)
    end
  end
end
