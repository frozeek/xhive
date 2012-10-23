module Xhive
  module Router
    class Cells
      # Public: draws the internal widget routes for cell based widgets.
      #
      # Example:
      #
      #   Xhive::Routes.draw do |router|
      #     mount 'my_widget', :to => 'my_cell#action'
      #   end
      #
      def self.draw
        yield self
      end

      # Public: mounts a cell based route and creates the Liquid tag.
      #
      # route   - The String containing the route.
      # options - The Hash containing the route endpoint.
      #
      # Example: mount 'my_widget', :to => 'my_cell#action'
      #
      def self.mount(route, options)
        cell, action = options[:to].split('#')
        widgets_base_route = Base.route_for('widgets', 'show').gsub(/\/\*\w*$/, '')
        widget_route = "#{widgets_base_route}/#{route}"
        tag_class_name = "#{cell}_#{action}".classify

        Route.add(widget_route, cell.classify, action)

        Xhive::TagFactory.create_class(tag_class_name, widget_route)
      end
    end
  end
end
