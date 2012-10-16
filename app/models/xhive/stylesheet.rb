require 'friendly_id'

module Xhive
  class Stylesheet < ActiveRecord::Base
    extend ::FriendlyId
    friendly_id :name, use: :slugged

    include Xhive::Presentable

    attr_accessible :content, :name, :slug, :site

    belongs_to :site

    validates :name, :presence => true, :uniqueness => { :scope => :site_id }
    validates :content, :presence => true
    validates :site, :presence => true
  end
end
