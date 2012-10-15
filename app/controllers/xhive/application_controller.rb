module Xhive
  class ApplicationController < ActionController::Base
    prepend_before_filter :set_current_controller

    helper_method :safe_user

    # Private: Returns a safe user, e.i. a logged user or a guest user.
    #
    # This is just a placeholder and should be implemented in the host app.
    #
    # Example:
    #
    # def safe_user
    #   current_user || AnonymousUser.new
    # end
    #
    # Returns: an anonymous user.
    #
    def safe_user
      AnonymousUser.new
    end

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
