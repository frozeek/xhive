module Xhive
  class PagePresenter < Xhive::BasePresenter
    presents :page
    delegate :name, :title, :content, :meta_keywords, :meta_description, :to => :page

    liquid_methods :name, :title, :content, :meta_keywords, :meta_description

    def render_content(options={})
      layout = ::Liquid::Template.parse("{{content}}").render({"content" => page.content})
      text = ::Liquid::Template.parse(layout).render(
        {'page' => self, 'user' => controller.safe_user.presenter}.merge(options),
        :registers => {:controller => controller}
      )
      result = text.html_safe
    rescue => e
      logger.debug "#{e.class.name}: #{e.message}"
      logger.debug e.backtrace.join("/n")
      result = ''
    ensure
      return result
    end
  end
end
