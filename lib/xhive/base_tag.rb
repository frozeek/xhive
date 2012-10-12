require 'uri'
require 'liquid'

module Xhive
  class BaseTag < ::Liquid::Tag
    # Public: initializes the tag. Also stores the passed attributes.
    #
    # Example: transforms this liquid meta tag {% some_tag attr1:foo attr2:bar %}
    #          into #<SomeTag attributes: { :attr1 => 'foo', :attr2 => 'bar' }>
    #
    def initialize(tag_name, markup, tokens)
      @attributes = {}
      markup.scan(::Liquid::TagAttributes) do |key, value|
        # Remove single or double quotes around the quoted fragment before storing them in attributes
        @attributes[key.to_sym] = value.gsub("'",'').gsub('"','')
      end
      super
    end

    # Public: renders the tag.
    #
    # context - The hash containing a set of external attributes.
    #
    # Returns: the rendered tag or a list of errors.
    #
    def render(context)
      if (errors = check_parameters).empty?
        process_parameters(context)
        html = "<div "
        html << " data-widget='true'"
        html << " data-url='#{rest_url}'"
        html << " data-params='#{parameters_to_args}'"
        html << "></div>"
      else
        errors
      end
    end

  private

    # Private: checks the attributes to see if there is any required
    #          param missing.
    #
    # Returns: a list with the error descriptions.
    #
    def check_parameters
      errors = ""
      @url.scan(/:(\w*)/).flatten.map(&:to_sym).each do |arg|
        errors += "<li><p>parameter '#{arg.to_s}' is required</p></li>" unless @attributes.has_key?(arg)
      end
      errors.empty? ? "" : "<ul>#{errors}</ul>"
    end

    # Private: replaces any REST-like attributes in the url.
    #
    # Returns: a new url with populated parameters.
    #
    def rest_url
      URI.encode(@url.gsub(/:(\w*)/) { "%{#{$1}}" } % @attributes)
    end

    # Private: replaces each attribute with its actual value.
    #
    def process_parameters(context)
      @attributes.each {|k, v| @attributes[k] = process_value(v, context)}
    end

    # Private: transforms a parameters hash into a query string.
    #
    def parameters_to_args
      @attributes.except(:id).map {|k,v| "#{k.to_s}=#{CGI.escape(v.to_s.gsub(/\'/,'').gsub(/\"/,''))}"}.join("&")
    end

    # Private: checks if the value is a meta variable and grabs its value from the context if so.
    #
    # Returns: the raw attribute value or the context value.
    #
    def process_value(value, context)
      # If the value contains a meta variable, get it from the context
      if value =~ /\{\{(.*)\}\}/
        context[$1]
      else
        value
      end
    end
  end
end


