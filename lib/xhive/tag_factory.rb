module Xhive
  class TagFactory
    # Public: creates and registers the tag class for a specific name/url pair.
    #
    # name - The String containing the widget name.
    # url  - The String containing the widget url.
    #
    def self.create_class(name, url)
      klass = Class.new(Xhive::BaseTag) do
        const_set 'URL', url
        def initialize(tag_name, markup, tokens)
          @url = self.class.const_get 'URL'
          super
        end
      end

      Liquid.const_set name, klass
      Liquid::Template.register_tag(name.underscore, "Liquid::#{name}".constantize)
    end
  end
end
