module Xhive
  module Presentable
    def presenter
      klass = presenter_class.constantize
      klass.new(self)
    end

    def presenter_class
      self.class.klass_name || "#{self.class.name}Presenter"
    end

    module ClassMethods
      @klass_name = nil

      def presenter_class=(class_name)
        @klass_name = class_name
      end

      def klass_name
        @klass_name
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end
