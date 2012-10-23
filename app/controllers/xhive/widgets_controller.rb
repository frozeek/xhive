require_dependency "xhive/application_controller"

module Xhive
  class WidgetsController < ApplicationController
    def show
      # Looks for a route matching the request path
      route = extract_route
      parameters = extract_parameters(route)
      render :text => rendered_cell_content(route, parameters), :status => 200
    rescue => e
      render :text => 'Not found', :status => 404
    end

  private

    # Private: finds the requested route in the internal route map.
    #
    # Returns: a route object.
    #
    def extract_route
      Xhive::Router::Route.find(request.path)
    end

    # Private: extracts the parameters from the request path and the query string.
    #
    # route - The Route object obtained from the request.
    #
    # Returns: a hash containing the request parameters.
    #
    def extract_parameters(route)
      route.params_from(request.path).merge(params).with_indifferent_access
    end

    # Private: renders the corresponding cell#action.
    #
    # route      - The Route object obtained from the request.
    # parameters - The Hash containing the request parameters.
    #
    # Returns: the rendered content.
    #
    def rendered_cell_content(route, parameters)
      render_cell(route.klass.underscore.to_sym, route.action.to_sym, parameters)
    end
  end
end
