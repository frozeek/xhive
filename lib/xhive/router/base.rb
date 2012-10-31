module Xhive
  module Router
    class Base
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
        url = ''
        routes = normalized_routes
        url = routes.to_a.select {|route| route[:end_point] == "#{controller}##{action}"}.first.fetch(:path)
        url = url.gsub('(.:format)', '')
        url
      rescue
        Rails.logger.error "#{Error.class.name}:#{controller}##{action}"
      ensure
        return url
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
end
