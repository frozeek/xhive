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
        class_variable_set("@@routes", [])
        yield self
      end

      # Public: mounts a cell based route and creates the Liquid tag.
      #
      # route   - The String containing the route.
      # options - The Hash containing the route endpoint.
      #
      # Example: mount 'my_widget', :to => 'my_cell#action'
      #
      # It stores the route in internal storage for later processing
      #
      def self.mount(route, options)
        @@routes << { :path => route, :options => options }
      end

      # Public: process the previously stored routes
      #
      def self.process_routes
        return unless defined?(@@routes)

        @@routes.each do |route|
          path = route[:path]
          options = route[:options]

          cell, action = options[:to].split('#')
          widgets_base_route = Base.route_for('widgets', 'show').gsub(/\/\*\w*$/, '')
          widget_route = "#{widgets_base_route}/#{path}"
          tag_class_name = (options[:as] || "#{cell}_#{action}").to_s.classify.gsub('::', '')

          Route.add(widget_route, cell, action, options.except(:to))

          Xhive::TagFactory.create_class(tag_class_name, widget_route)
        end
      end
    end
  end
end
