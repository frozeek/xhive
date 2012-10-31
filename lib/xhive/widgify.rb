module Xhive
  module Widgify
    # Public: remove layout from action and create Liquid tag class.
    #
    # actions - The array of actions to widgify.
    #
    def widgify(*actions)
      actions.each do |action|
        remove_layout_for_action(action)
        Xhive::TagFactory.create_class(tag_name_for(action), route_for(action))
      end
    end

    # Public: creates an array with the actions to exclude from layout.
    #
    def self.extended(base)
      base.class_variable_set "@@widgets_list", []
    end

  private

    # Private: returns the route definition for a controller#action pair.
    #
    # action - The string with the action name.
    #
    # Returns: the route definition. e.g. 'pages/:id/show'.
    #
    def route_for(action)
      Xhive::Router::Base.route_for(controller_path, action)
    end

    # Private: builds the tag name for a given action.
    #
    # action - The string with the action name.
    #
    # Returns: the tag name.
    #
    def tag_name_for(action)
      tag_name = "#{controller_name.capitalize}#{action.capitalize}"
    end

    # Private: adds the action to the widgets list and sets the layout to false.
    #
    # action - The string with the action name.
    #
    def remove_layout_for_action(action)
      self.class_variable_get("@@widgets_list") << action.to_sym
      self.layout :false, :only => self.class_variable_get("@@widgets_list")
    end
  end
end

