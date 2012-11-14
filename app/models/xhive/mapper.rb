module Xhive
  # Maps resources to pages.
  #
  class Mapper < ActiveRecord::Base
    attr_accessible :action, :page_id, :site_id, :resource, :key

    belongs_to :site
    belongs_to :page

    validates :resource, :presence => true
    validates :action, :presence => true
    validates :site, :presence => true
    validates :page, :presence => true

    # Public: looks for a page mapper and returns the associated page.
    #
    # site     - The Site to look into.
    # resource - The String containing the resource name filter.
    # action   - The String containing the action name filter.
    # key      - The String containing the key filter.
    #
    # Returns: the mapped page or nil if not found.
    #
    def self.page_for(site, resource, action, key = nil)
      mapper = find_map(site, resource, action, key)
      page = mapper.try(:page)
    end

    # Public: creates a mapper for a specific resource and page.
    #
    # site     - The Site to associate the mapper to.
    # page     - The Page object to map.
    # resource - The String containing the associated resource name.
    # action   - The String containing the associated action name.
    # key      - The String containing the associated key.
    #
    # Returns: true if created. False otherwise.
    #
    def self.map_resource(site, page, resource, action, key = nil)
      mapper = find_map(site, resource, action, key)
      mapper = new(:site_id => site.id, :resource => resource,
                   :action => action, :key => key.present? ? key : nil) unless mapper.present?
      mapper.page = page
      mapper.save
    end

    # Public: returns all the mappers for a specific resource.
    #
    # site     - The Site owner of the mappers.
    # resource - The String containing the resource to filter by.
    #
    # Returns: an ActiveRecord::Relation filtered by resource.
    #
    def self.all_by_resource(site, resource)
      where(:site_id => site.id).where(:resource => resource)
    end

  private

    # Private: looks for a mapper object.
    #
    # site     - The Site to look into.
    # resource - The String containing the resource name filter.
    # action   - The String containing the action name filter.
    # key      - The String containing the key filter.
    #
    # Returns: the mapper object or nil if not found.
    #
    def self.find_map(site, resource, action, key)
      mapper = where(:site_id => site.id)
      mapper = mapper.where(:resource => resource)
      mapper = mapper.where(:action => action)
      mapper = mapper.where(:key => key.present? ? key : nil)
      mapper.first
    end
  end
end
