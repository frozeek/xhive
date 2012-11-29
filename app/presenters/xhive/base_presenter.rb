module Xhive
  class BasePresenter
    attr_reader :object

    include ActionView::Helpers
    include ActionView::Context
    include Rails.application.routes.url_helpers

    default_url_options[:host] = (Rails.application.config.action_mailer.default_url_options || {}).fetch(:host, 'localhost')

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
  end
end
