module Xhive
  module Router
    class Error < StandardError
      def initialize(action)
        @action = action
        super
      end

      def message
        "No route was found for action #{@action}"
      end
    end
  end
end
