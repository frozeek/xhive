module Xhive
  module Routes
    def self.draw
      yield self
    end

    def self.mount(route, options)
      cell, action = options[:to].split('#')
      widget_route = "/widgets/#{route}"
      tag_class_name = "#{cell}_#{action}".classify

      Route.add(widget_route, cell.classify, action)

      TagFactory.create_class(tag_class_name, widget_route)
    end

    def self.match(route)
      Route.find(route)
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

      def self.add(route, klass, action)
        @@routes << new(route, klass, action)
      end

      def self.find(url)
        @@routes.select {|r| r.matches?(url) }.first
      end

      def matches?(url)
        matcher =~ url
      end

      def params_from(url)
        values = url.scan(matcher).flatten
        params = Hash[args.zip values]
      end

    private

      def matcher
        Regexp.new("^#{route.gsub(/\:[-\w]*/, '([-\w]*)')}$")
      end

      def extract_args(route)
        variables = route.scan(/:([-\w]*)/).flatten.map(&:to_sym)
      end
    end
  end
end

