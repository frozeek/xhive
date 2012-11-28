module Xhive
  module ApplicationHelper
    def initialize_widgets_loader
      "<script type='text/javascript'>WidgetLoader.load()</script>".html_safe
    end

    def include_custom_stylesheets
      "<link href='#{xhive.stylesheets_path}' media='all' rel='stylesheet' type='text/css'/>".html_safe
    end

    # Public: looks for a map and renders the corresponding page.
    #
    # key     - The String containing the key to look for (default = nil).
    # options - The Hash the data to pass to the rendered page.
    # block   - The block for a custom render if no map is found.
    #
    # Returns: the rendered page.
    #
    def render_page_with(key = nil, options={}, &block)
      page = Xhive::Mapper.page_for(current_site, controller_path, action_name, key, options)
      if page.present?
        render :inline => page.present_content(options), :layout => true
      else
        block_given? ? yield : render
      end
    end

    def current_site
      domain = request.host
      @current_site ||= Site.where(:domain => domain).first || Site.first
      fail "No Site defined. Please create a default Site." unless @current_site.present?
      @current_site
    end

    # Private: Returns a safe user, e.i. a logged user or a guest user.
    #
    # This is just a placeholder and should be implemented in the host app.
    #
    # Example:
    #
    # def safe_user
    #   current_user || AnonymousUser.new
    # end
    #
    # Returns: an anonymous user.
    #
    def safe_user
      AnonymousUser.new
    end
  end
end
