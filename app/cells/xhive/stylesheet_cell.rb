module Xhive
  class StylesheetCell < BaseCell
    def inline(params)
      @stylesheet = Xhive::Stylesheet.find(params[:id])
      "<style type='text/css'>#{@stylesheet.presenter.compressed}</style>"
    end
  end
end
