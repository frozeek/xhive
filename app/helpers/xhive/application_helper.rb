module Xhive
  module ApplicationHelper
    def initialize_widgets_loader
      javascript_tag "WidgetLoader.load()"
    end
  end
end
