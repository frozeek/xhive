module Xhive
  module Controller
    def current_controller
      self.class_variable_get "@@current_controller"
    end

    def self.extended(base)
      base.class_eval do
        @@current_controller = nil

        include InstanceMethods

        prepend_before_filter :set_current_controller
      end
    end
  end

  module InstanceMethods
    # This is to access the current_controller from within presenters
    def set_current_controller
      @@current_controller = self
    end
  end
end
