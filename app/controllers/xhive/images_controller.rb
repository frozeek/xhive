require_dependency "xhive/application_controller"

module Xhive
  class ImagesController < ApplicationController
    def show
      @image = current_site.images.where(:image => "#{params[:id]}.#{params[:format]}").first
      fail ActiveRecord::RecordNotFound unless @image.present?
      redirect_to @image.image_url, :status => 301
    end
  end
end
