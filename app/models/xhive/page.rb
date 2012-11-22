require 'friendly_id'

module Xhive
  class Page < ActiveRecord::Base
    extend ::FriendlyId
    friendly_id :name, use: :slugged

    include Xhive::Presentable

    attr_accessible :content, :meta_description, :meta_keywords, :name, :slug, :title, :site_id

    belongs_to :site

    validates :name, :presence => true, :uniqueness => { :scope => :site_id }
    validates :title, :presence => true
    validates :content, :presence => true
    validates :site, :presence => true

    def present_content(opts={})
      presenter.render_content(opts)
    end

    def present_title(opts={})
      presenter.render_title(opts)
    end
  end
end
