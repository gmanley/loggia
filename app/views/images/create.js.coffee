$(".thumbnails").append "<%= escape_javascript(render 'image', image: @image) %>"
authenticity_token = "<%= form_authenticity_token %>"
session_token = "<%= request.session_options[:id] %>"