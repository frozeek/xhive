module Xhive
  class StylesheetPresenter < Xhive::BasePresenter
    presents :stylesheet
    delegate :name, :content, :to => :stylesheet

    liquid_methods :name, :content, :compressed

    def compressed
      self.class.compress(stylesheet.content)
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
  end
end
