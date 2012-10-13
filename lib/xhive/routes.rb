module Xhive
  module Routes
    # Public: draws the internal widget routes for cell based widgets.
    #
    # Example:
    #
    #   Xhive::Routes.draw do |router|
    #     mount 'my_widget', :to => 'my_cell#action'
    #   end
    #
    def self.draw
      Rails.application.reload_routes!
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
      widgets_base_route = route_for('widgets', 'show').gsub(/\/\*\w*$/, '')
      widget_route = "#{widgets_base_route}/#{route}"
      tag_class_name = "#{cell}_#{action}".classify

      Route.add(widget_route, cell.classify, action)

      TagFactory.create_class(tag_class_name, widget_route)
    end

    # Public: returns the route that matches the url.
    #
    # url - The String containing the url to match.
    #
    # Returns: an Route object.
    #
    def self.match(url)
      Route.find(url)
    end

    # Public: returns the route definition for a controller#action pair.
    #
    # controller - The String containing the controller name.
    # action     - The String containing the action name.
    #
    # Returns: the route definition. e.g. 'pages/:id/show'.
    #
    def self.route_for(controller, action)
      routes = normalized_routes
      url = routes.to_a.select {|route| route[:end_point] == "#{controller}##{action}"}.first.fetch(:path)
      url = url.gsub('(.:format)', '')
      url
    rescue
      fail XhiveRouteError, "#{controller_name}##{action}"
    end

    class Route
      @@routes = []

      attr :route, :klass, :action, :args

      def initialize(route, klass, action)
        @route = route
        @klass = klass
        @action = action
        @args = extract_args(route)
      end

      # Public: adds a new route to the collection.
      #
      # route  - The String containing the route definition.
      # klass  - The String containing the Controller/Cell class name.
      # action - The String containing the action name.
      #
      def self.add(route, klass, action)
        @@routes << new(route, klass, action)
      end

      # Public: finds the route that matches the url.
      #
      # url - The String containing the url.
      #
      # Returns: a Route object that matches the url.
      #
      def self.find(url)
        @@routes.select {|r| r.matches?(url) }.first
      end

      # Public: checks if the route matches the url.
      #
      # url - The String containing the url to match.
      #
      # Returns: true or false.
      #
      def matches?(url)
        !!(matcher =~ url)
      end

      # Public: returns the parameters present in the url.
      #
      # url - The String containing the url.
      #
      # Returns: a hash of the form { :id => '1', :name => 'john' }
      #
      def params_from(url)
        values = url.scan(matcher).flatten
        params = Hash[args.zip values]
      end

    private

      # Private: returns a regexp matcher for the route.
      #
      # Returns: a Regexp object with the route matcher.
      #
      def matcher
        Regexp.new("^#{route.gsub(/\:[-\w]*/, '([-\w]*)')}$")
      end

      # Private: extracts the argument names from a given url.
      #
      # url - The String containing the url.
      #
      # Returns: an array of argument names.
      #
      def extract_args(url)
        variables = url.scan(/:([-\w]*)/).flatten.map(&:to_sym)
      end
    end

    class XhiveRouteError < StandardError
      def initialize(action)
        @action = action
        super
      end

      def message
        "No route was found for action #{@action}"
      end
    end

  private

    # Private: joins the Rails application routes and the Xhive::Engine routes.
    #
    # Returns: an array of normalized routes.
    #
    def self.normalized_routes
      load_routes_for(Rails.application.routes) | load_routes_for(Xhive::Engine.routes)
    end

    # Private: returns an array of normalized routes.
    #
    # Example: [{:end_point => 'pages#show', :path => '/pages/:id/show'}]
    #
    # Returns: an array with a set of normalized routes.
    #
    def self.load_routes_for(router)
      # TODO: find another way to get the routes prefix. This might get changed as is not public API.
      mount_point = router._generate_prefix({}).to_s
      routes = router.routes.to_a
      routes.collect do |route|
        if route.requirements[:controller] && route.requirements[:action]
          controller = route.requirements[:controller].gsub(/rails\/|xhive\//, '')
          action = route.requirements[:action]
          path = route.path.spec.to_s
          { :end_point => "#{controller}##{action}", :path => "#{mount_point}#{path}" }
        end
      end.compact
    end
  end
end

