module Xhive
  class Mapper < ActiveRecord::Base
    attr_accessible :action, :page, :site, :resource

    belongs_to :site
    belongs_to :page

    validates :resource, :presence => true
    validates :action, :presence => true
    validates :site, :presence => true
    validates :page, :presence => true

    def self.page_for(resource, action)
      page = where(:resource => resource).where(:action => action).first.try(:page)
      fail ActiveRecord::RecordNotFound unless page.present?
      page
    end
  end
end
