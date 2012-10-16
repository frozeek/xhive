module Xhive
  module ApplicationHelper
    def initialize_widgets_loader
      "<script type='text/javascript'>WidgetLoader.load()</script>".html_safe
    end
  end
end
