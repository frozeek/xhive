require 'friendly_id'

module Xhive
  class Page < ActiveRecord::Base
    extend ::FriendlyId
    friendly_id :name, use: :slugged

    include Xhive::Presentable

    attr_accessible :content, :meta_description, :meta_keywords, :name, :slug, :title, :site

    belongs_to :site

    validates :name, :presence => true
    validates :title, :presence => true
    validates :content, :presence => true
    validates :site, :presence => true
  end
end
