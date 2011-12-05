ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  if html_tag.start_with?('<label')
    %(<div class=\"error clearfix\">#{html_tag}).html_safe
  else
    if html_tag.include?('class=')
      html_tag = html_tag.gsub('class="', 'class="error ')
    else
      html_tag = html_tag.gsub('name=', 'class="error" name=')
    end

    if instance.error_message.kind_of?(Array)
      %(#{html_tag}<span class="help-inline">#{instance.method_name.titleize} #{instance.error_message.join(',')}</span>).html_safe
    else
      %(#{html_tag}<span class="help-inline">#{instance.method_name.titleize} #{instance.error_message}</span></div>).html_safe
    end
  end
end