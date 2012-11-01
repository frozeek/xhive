require 'carrierwave'
require 'carrierwave/orm/activerecord'

module Xhive
  class Image < ActiveRecord::Base
    belongs_to :site

    attr_accessible :image, :site_id, :title

    validates :image, :presence => true
    validates :site, :presence => true

    mount_uploader :image, ImageUploader

    def basename
      File.basename(image.to_s)
    end
  end
end
