module Xhive
  class Image < ActiveRecord::Base
    belongs_to :site

    attr_accessible :image, :site_id, :title

    validates :image, :presence => true
    validates :site, :presence => true
  end
end
