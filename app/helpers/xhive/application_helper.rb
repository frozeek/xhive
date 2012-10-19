module Xhive
  module ApplicationHelper
    def initialize_widgets_loader
      "<script type='text/javascript'>WidgetLoader.load()</script>".html_safe
    end

    def include_custom_stylesheets
      "<link href='#{stylesheets_path}' media='all' rel='stylesheet' type='text/css'/>".html_safe
    end
  end
end
