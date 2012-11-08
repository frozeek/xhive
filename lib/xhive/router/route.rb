module Xhive
  module Router
    class Route
      @@routes = []

      attr :route, :klass, :action, :args, :inline

      def initialize(route, klass, action, opts={})
        @route = route
        @klass = klass
        @action = action
        @args = extract_args(route)
        @inline = opts[:inline] || false
      end

      # Public: adds a new route to the collection.
      #
      # route  - The String containing the route definition.
      # klass  - The String containing the Controller/Cell class name.
      # action - The String containing the action name.
      # inline - The Boolean indicating if it should be rendered inline or as an AJAX widget.
      #
      def self.add(route, klass, action, inline)
        @@routes << new(route, klass, action, inline)
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
  end
end
