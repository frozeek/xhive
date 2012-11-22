module Xhive
  class PagePresenter < Xhive::BasePresenter
    presents :page
    delegate :name, :title, :content, :meta_keywords, :meta_description, :to => :page

    liquid_methods :name, :title, :content, :meta_keywords, :meta_description

    # Public: renders the page content.
    #
    # options - The Hash containing the values to use inside the template.
    #
    # Returns: the rendered page content.
    #
    def render_content(options={})
      liquified = LiquidWrapper.liquify_objects(options)
      layout = ::Liquid::Template.parse("{{content}}").render({"content" => page.content})
      text = ::Liquid::Template.parse(layout).render(
        {'page' => self, 'user' => controller.try(:safe_user).try(:presenter)}.merge(liquified.stringify_keys),
        :registers => {:controller => controller}
      )
      result = text.html_safe
    rescue => e
      logger.error "#{e.class.name}: #{e.message}"
      logger.error e.backtrace.join("/n")
      result = ''
    ensure
      return result
    end

    # Public: renders the page title.
    #
    # options - The Hash containing the values to use inside the template.
    #
    # Returns: the rendered page title.
    #
    def render_title(options={})
      liquified = LiquidWrapper.liquify_objects(options)
      result = ::Liquid::Template.parse(title).render(liquified.stringify_keys)
    rescue => e
      logger.error "#{e.class.name}: #{e.message}"
      logger.error e.backtrace.join("/n")
      result = ''
    ensure
      return result
    end
  end
end
