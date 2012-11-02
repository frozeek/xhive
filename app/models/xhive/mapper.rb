module Xhive
  class Mapper < ActiveRecord::Base
    attr_accessible :action, :page_id, :site_id, :resource, :key

    belongs_to :site
    belongs_to :page

    validates :resource, :presence => true
    validates :action, :presence => true
    validates :site, :presence => true
    validates :page, :presence => true

    def self.page_for(site, resource, action, key = nil)
      mapper = find_map(site, resource, action, key)
      page = mapper.try(:page)
      fail ActiveRecord::RecordNotFound unless page.present?
      page
    end

    def self.map_resource(site, page, resource, action, key = nil)
      mapper = find_map(site, resource, action, key)
      mapper = new(:site_id => site.id, :resource => resource, :action => action, :key => key) unless mapper.present?
      mapper.page = page
      mapper.save
    end

  private

    def self.find_map(site, resource, action, key)
      mapper = where(:site_id => site.id).where(:resource => resource).where(:action => action)
      mapper = mapper.where(:key => key) if key.present?
      mapper.first
    end
  end
end
