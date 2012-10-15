module Xhive
  # Adds the ability to get/set an attribute using the dot operator
  #
  # Examples
  #
  #   a = Hashy.new
  #   a.foo # => nil
  #   a.foo = 'bar'
  #   a.foo # => 'bar'
  #
  #   a = Hashy.new(:foo => 'bar')
  #   a.foo # => 'bar'
  #   a.duu # => nil
  #
  class Hashy < Hash
    # Public: initializer
    #
    # attrs - The Hash containing the initial elements (default: {})
    #
    # Returns an instance of Hashy
    def initialize(attrs={})
      super
      attrs.each {|k,v| self[k.to_sym] = v }
    end

  private

    def method_missing(sym, *args, &block)
      # If I receive a method with the form 'foo='
      if sym.to_s =~ /=/
        attr = sym.to_s.scan(/(\w*)=/)
        self[attr[0][0].to_sym] = args[0] unless attr.empty?
      elsif sym.to_s =~ /^.*\?$/
        attr = sym.to_s.scan(/(\w*)\?/)
        self.fetch(attr[0][0].to_sym, false) ? true : false
      else
        # This should be the standard behavior with []
        self.fetch(sym, nil)
      end
    end
  end
end
