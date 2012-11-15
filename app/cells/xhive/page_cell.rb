module Xhive
  class PageCell < Cell::Base
    def inline(params)
      site = params[:site].present? ? Xhive::Site.find(params[:site]) : Xhive::Site.first
      page = site.pages.find(params[:id])
      page.present_content(params)
    end
  end
end
