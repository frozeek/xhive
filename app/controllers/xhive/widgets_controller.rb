require_dependency "xhive/application_controller"

module Xhive
  class WidgetsController < ApplicationController
    def show
      # Looks for a route matching the request path
      route = Xhive::Routes::Route.find(request.path)
      # Gets the parameters from the request path and the query string
      parameters = route.params_from(request.path).merge(params).with_indifferent_access
      # Renders the corresponding cell#action
      render :text => render_cell(route.klass.underscore.to_sym, route.action.to_sym, parameters), :status => 200
    rescue => e
      render :text => 'Not found', :status => 404
    end
  end
end
