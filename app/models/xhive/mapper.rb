module Xhive
  class Mapper < ActiveRecord::Base
    attr_accessible :action, :page_id, :site_id, :resource

    belongs_to :site
    belongs_to :page

    validates :resource, :presence => true
    validates :action, :presence => true
    validates :site, :presence => true
    validates :page, :presence => true

    def self.page_for(resource, action, key = nil)
      mapper = where(:resource => resource).where(:action => action)
      mapper = mapper.where(:key => key) if key.present?
      page   = mapper.first.try(:page)
      fail ActiveRecord::RecordNotFound unless page.present?
      page
    end
  end
end
