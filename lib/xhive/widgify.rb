module Xhive
  module Widgify
    def widgify(*actions)
      actions.each do |action|
        remove_layout_for_action(action)
        Xhive::TagFactory.create_class(tag_name_for(action), route_for(action))
      end
    end

    def self.extended(base)
      base.class_variable_set "@@widgets_list", []
    end

  private

    def tag_name_for(action)
      controller_name = self.name.gsub(/Controller|Xhive|::/, '')
      tag_name = "#{controller_name}#{action.capitalize}"
    end

    def route_for(action)
      routes = normalized_routes
      url = routes.to_a.select {|route| route[:end_point] == "#{controller_name}##{action.to_s}"}.first.fetch(:path)
      url = url.gsub('(.:format)', '')
      url
    rescue
      fail WidgetRouteError, action
    end

    def normalized_routes
      routes = Rails.application.routes.routes.to_a | Xhive::Engine.routes.routes.to_a
      routes.collect do |route|
        if route.requirements[:controller] && route.requirements[:action]
          controller = route.requirements[:controller].gsub(/rails\/|xhive\//, '')
          action = route.requirements[:action]
          path = route.path.spec.to_s
          { :end_point => "#{controller}##{action}", :path => path }
        end
      end.compact
    end

    def remove_layout_for_action(action)
      self.class_variable_get("@@widgets_list") << action.to_sym
      self.layout :false, :only => self.class_variable_get("@@widgets_list")
    end

    class WidgetRouteError < StandardError
      def initialize(action)
        @action = action
        super
      end

      def message
        "No route was found for action :#{@action}"
      end
    end
  end
end

