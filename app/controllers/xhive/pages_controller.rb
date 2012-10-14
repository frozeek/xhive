require_dependency "xhive/application_controller"

module Xhive
  class PagesController < ApplicationController
    extend Xhive::Widgify

    widgify :widget

    before_filter :load_page

    def show
    end

    def widget
      render :show
    end

  private

    def load_page
      @page = current_site.pages.find(params[:id])
    end
  end
end
