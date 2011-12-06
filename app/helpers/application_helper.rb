# encoding: UTF-8
module ApplicationHelper

  def flash_messages
    flash.select{|name, msg| msg.is_a?(String)}.each do |name, msg|
      haml_tag :div, class: "alert-message #{name} fade in", data: {alert: 'alert'} do
        haml_tag 'a.close', '×', href: '#'
        haml_tag :p, msg
      end
    end
  end
end
