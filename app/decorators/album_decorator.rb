class AlbumDecorator < Draper::Base
  decorates :album
  decorates_association :children
  decorates_association :parent

  def display_name
    "#{event_date} #{title}".strip.html_safe
  end

  def title
    h.content_tag(:span, self[:title], class: 'album-title')
  end

  def updated_at
    h.content_tag :p, class: 'album-updated-at muted' do
      h.haml_concat 'Last updated '
      h.haml_tag 'time.timeago', datetime: self[:updated_at].iso8601 do
        self[:updated_at]
      end
    end
  end

  def event_date
    if self[:event_date]
      h.content_tag(:span, formated_event_date, class: 'muted')
    end
  end
end
