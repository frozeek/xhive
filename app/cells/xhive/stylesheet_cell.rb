module Xhive
  class StylesheetCell < BaseCell
    def inline(params)
      site = params[:site].present? ? Xhive::Site.find(params[:site]) : Xhive::Site.first
      stylesheet = site.stylesheets.find(params[:id])
      "<style type='text/css'>#{stylesheet.presenter.compressed}</style>"
    end
  end
end
