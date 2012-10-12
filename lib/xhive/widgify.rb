module Xhive
  module Widgify
    def widgify(*actions)
      actions.each do |action|
        remove_layout_for_action(action)
        TagFactory.create_class(tag_name_for(action), route_for(action))
      end
    end

    def self.extended(base)
      base.class_variable_set "@@widgets_list", []
    end

  private

    def tag_name_for(action)
      controller_name = self.name.gsub('Controller', '')
      tag_name = "#{controller_name}#{action.capitalize}"
    end

    def route_for(action)
      routes = Rails.application.routes.routes
      url = routes.to_a.select {|r| r.defaults[:controller] == controller_name and r.defaults[:action] == action.to_s}.first.ast.to_s
      url = url.gsub('(.:format)', '')
      url
    end

    def remove_layout_for_action(action)
      self.class_variable_get("@@widgets_list") << action.to_sym
      self.layout :false, :only => self.class_variable_get("@@widgets_list")
    end
  end
end

