module Xhive
  # Wrapper to add liquid_method to all of object attributes.
  class LiquidWrapper
    def initialize(object)
      @object = object
    end

    # Public: liquid interface.
    #
    # Returns: object attributes or an empty Array.
    #
    def to_liquid
      @object.respond_to?(:attributes) ? @object.attributes : []
    end

    # Public: builds wrapper around each collection object.
    #
    # objects - The Hash containing the objects.
    #
    # Returns: the objects hash with the objects wrappers.
    #
    def self.liquify_objects(objects)
      objects.each do |k, v|
        objects[k] = liquify(v)
      end
    end

    # Public: builds a liquid wrapper around the object.
    #
    # object - The object to wrap.
    #
    # Returns: the same object (if it is already liquified) or a liquid wrapper.
    #
    def self.liquify(object)
      object.respond_to?(:to_liquid) ? object : new(object)
    end

    # Delegate methods to wrapped object
    def method_missing(sym, *args, &block)
      @object.send sym, *args, &block
    end
  end
end
