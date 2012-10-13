class @WidgetLoader
  @load: ->
    $widgets = []

    $("[data-widget='true']").each((index) ->
      $widget = $(this)
      baseUrl = $widget.data('url')
      args = $widget.data('params')
      url = "#{baseUrl}?#{args}"
      $widgets.push $.ajax({
        url: url,
        success: (data) ->
          $widget.html(data)
          $widget.attr('data-widget', 'false')
      })
    )

    if $widgets.length > 0
      $.when.apply(null, $widgets).then( ->
        WidgetLoader.load()
      )

