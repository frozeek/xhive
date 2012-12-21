module Xhive
  class BasePresenter
    attr_reader :object

    include ActionView::Helpers
    include ActionView::Context
    include Rails.application.routes.url_helpers

    default_url_options[:host] = (Rails.application.config.action_mailer.default_url_options || {}).fetch(:host, 'localhost')
    default_url_options[:port] = (Rails.application.config.action_mailer.default_url_options || {}).fetch(:port, '3000')

    def initialize(object)
      @object = object
    end

    def id
      @object.id
    end

    def safe_user
      controller.try(:safe_user).try(:presenter)
    end

  private

    def controller
      ApplicationController.current_controller
    end

    def self.presents(name)
      define_method(name) do
        @object
      end
    end

    # Private: returns the xhive url for the requested resource
    #
    def url_for(resource, params = {}, options = {})
      Xhive.railtie_routes_url_helpers.send("#{resource}_url", params, options.merge(default_url_options))
    end

    # Private: returns the xhive url for the requested resource
    #
    def path_for(resource, params = {})
      url_for(resource, params, :only_path => true)
    end

    # Private: returns the base images path
    #
    def base_images_path
      path_for('image', 'sample.png').gsub('/sample.png', '')
    end
  end
end
