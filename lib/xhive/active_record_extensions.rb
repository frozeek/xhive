module Xhive
  module ActiveRecordExtensions
    extend ActiveSupport::Concern

    module ClassMethods
      def mount_page(attr)
        # Define getter
        define_method(attr.to_s) do
          # TODO: support multiple sites
          site = Xhive::Site.first
          begin
            page = Xhive::Mapper.page_for(site, self.class.name.downcase, attr.to_s, id)
          rescue ActiveRecord::RecordNotFound
            page = nil
          end
          return page
        end

        # Define setter
        define_method("#{attr}=") do |value|
          fail RecordNotPersistedError, "Cannot assign a page to an unsaved #{self.class.name}" if new_record?
          # TODO: support multiple sites
          site = Xhive::Site.first
          page = value.is_a?(Xhive::Page) ? value : site.pages.find(value)
          Xhive::Mapper.map_resource(site, page, self.class.name.downcase, attr.to_s, id)
        end

        # Define content
        define_method("#{attr}_content") do |opts={}|
          self.send(attr.to_sym).present_content(opts.merge({self.class.name.downcase.to_sym => self}))
        end
      end
    end

    class RecordNotPersistedError < StandardError; end
  end
end
