module Xhive
  class StylesheetPresenter < Xhive::BasePresenter
    presents :stylesheet
    delegate :name, :to => :stylesheet

    liquid_methods :name, :content, :compressed

    def content
      filter_images_urls(stylesheet.content)
    end

    def compressed
      self.class.compress(content)
    end

    def self.all_compressed(stylesheets)
      stylesheets.inject('') do |result, stylesheet|
        result << compress(stylesheet.content)
      end
    end

  private

    # Private: compress stylesheet content
    #
    # content - The string containing the stylesheet content
    #
    # Returns: the compressed CSS
    #
    def self.compress(content)
      engine = Sass::Engine.new(content, :syntax => :scss, :style => :compressed)
      engine.render
    end

    def filter_images_urls(content)
      images_path = base_images_path
      content.gsub(/url\(['"]?#{images_path}\/([^\'^\"]+)['"]?\)/) {|| "url('#{url_for('image', $1)}')"}
    end
  end
end
