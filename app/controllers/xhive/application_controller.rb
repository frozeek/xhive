module Xhive
  class ApplicationController < ActionController::Base
    prepend_before_filter :set_current_controller

  private

    def current_site
      domain = request.host
      @current_site ||= Site.where(:domain => domain).first || Site.first
      fail "No Site defined. Please create a default Site." unless @current_site.present?
      @current_site
    end

    # This is to access the current_controller from within presenters
    def set_current_controller
      @@current_controller = self
    end

    def self.current_controller
      @@current_controller
    end
  end
end
