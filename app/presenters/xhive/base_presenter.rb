module Xhive
  class BasePresenter
    attr_reader :object

    include ActionView::Helpers
    include ActionView::Context
    include Rails.application.routes.url_helpers

    default_url_options[:host] = load_default_url_options

    def initialize(object)
      @object = object
    end

    def id
      @object.id
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

    def load_default_url_options
      options = Rails.application.config.action_mailer.default_url_options || {}
      options.fetch(:host, "localhost")
    end
  end
end
