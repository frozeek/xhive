require_dependency "xhive/application_controller"

module Xhive
  class StylesheetsController < ApplicationController
    respond_to :css

    def index
      render :text => StylesheetPresenter.all_compressed(Stylesheet.all)
    end

    def show
      @style = Stylesheet.find(params[:id])
      render :text => @style.presenter.compressed
    end
  end
end
