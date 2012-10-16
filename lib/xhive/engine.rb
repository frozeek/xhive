require "cells"

module Xhive
  class Engine < ::Rails::Engine
    isolate_namespace Xhive
    ::Cell::Base.prepend_view_path('app/cells')
    initializer "xhive.extend_application_controller" do
      ActiveSupport.on_load(:action_controller) do
        extend Xhive::Widgify
        include Xhive::ApplicationHelper
        helper_method :initialize_widgets_loader
      end
    end
    initializer "xhive.load_all_controller_classes" do
      ActiveSupport.on_load(:action_controller) do
        Rails.application.reload_routes!
        Dir[Rails.root.join("app/controllers/**/*.rb")].each {|f| require f}
      end
    end
  end
end
