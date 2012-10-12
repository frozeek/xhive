module Xhive
  class ApplicationController < ActionController::Base
    prepend_before_filter :set_current_controller

  private

    # This is to access the current_controller from within presenters
    def set_current_controller
      @@current_controller = self
    end

    def self.current_controller
      @@current_controller
    end
  end
end
