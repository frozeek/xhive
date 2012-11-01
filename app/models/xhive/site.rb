module Xhive
  class Site < ActiveRecord::Base
    attr_accessible :domain, :name, :home_page_id

    has_many :pages
    has_many :mappers
    has_many :stylesheets
    has_many :images

    belongs_to :home_page, :class_name => 'Page'

    validates :name, :presence => true
    validates :domain, :presence => true
  end
end
