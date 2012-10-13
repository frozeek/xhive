module Xhive
  class Site < ActiveRecord::Base
    attr_accessible :domain, :name, :home_page

    has_many :pages
    belongs_to :home_page, :class_name => 'Page'

    validates :name, :presence => true
    validates :domain, :presence => true
  end
end
