require "cells"

module Xhive
  class Engine < ::Rails::Engine
    isolate_namespace Xhive
    ::Cell::Base.prepend_view_path('app/cells')
    initializer "xhive.extend_application_controller" do
      ActiveSupport.on_load(:action_controller) do
        extend Xhive::Widgify
        extend Xhive::Controller

        include Xhive::ApplicationHelper

        helper_method :initialize_widgets_loader, :include_custom_stylesheets
      end
    end
    initializer "xhive.load_all_controller_classes", :after=> :disable_dependency_loading do
      ActiveSupport.on_load(:action_controller) do
        Dir[Rails.root.join("app/controllers/**/*.rb")].each {|f| require f}
        Xhive::Router::Cells.process_routes
      end
    end
  end
end
