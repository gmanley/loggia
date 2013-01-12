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
    h.content_tag(:p,
      "Last updated #{h.time_ago_in_words(self[:updated_at])} ago",
      class: 'album-updated-at muted'
    )
  end

  def event_date
    if self[:event_date]
      h.content_tag(:span, formated_event_date, class: 'muted')
    end
  end
end
