$ ->
  colorbox_init()
  $(".pagination a").live "click", (e) ->
    url = $(this).attr("href").replace(/^.*\/page\//, "#/page/")
    AjaxLinks.setLocation url
    e.preventDefault()

  AjaxLinks.run()

AjaxLinks = $.sammy("#content", ->
  @get "#/page/:page_number", ->
    $("#loading").fadeIn "fast"
    $("#content").load "/page/" + @params.page_number + " #content > *", ->
      $("#loading").fadeOut "fast"
      colorbox_init()
)

colorbox_init = ->
  $(".thumbnail").colorbox
    maxWidth: "95%"
    maxHeight: "95%"