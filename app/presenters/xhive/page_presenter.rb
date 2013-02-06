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
      layout = ::Liquid::Template.parse("{{content}}").render({"content" => page.content})
      result = ::Liquid::Template.parse(layout).render(optional_data(options), :registers => {:controller => controller}).html_safe
    rescue => e
      log_error(e)
    ensure
      return filter_images_urls(result.to_s)
    end

    # Public: renders the page title.
    #
    # options - The Hash containing the values to use inside the template.
    #
    # Returns: the rendered page title.
    #
    def render_title(options={})
      result = ::Liquid::Template.parse(title).render(optional_data(options))
    rescue => e
      log_error(e)
    ensure
      return result.to_s
    end

  private

    def optional_data(options)
      # wrap the options data to use it from liquid
      liquified = LiquidWrapper.liquify_objects(options)
      # build the optional data hash
      {'page' => self, 'user' => safe_user}.merge(liquified.stringify_keys)
    end

    def filter_images_urls(content)
      images_path = base_images_path
      # This only works if string is interpolated o_O
      "#{content}".gsub(/src\=['"]?#{images_path}\/([^\'^\"]+)['"]?/) {|| "src='#{image_url($1)}'"}
    end

    def image_url(image)
      url_for('image', image).gsub(/http:|https:/,'')
    end

    def log_error(e)
      logger.error "#{e.class.name}: #{e.message}"
      logger.error e.backtrace.join("/n")
    end
  end
end
