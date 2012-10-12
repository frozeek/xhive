module Xhive
  class Site < ActiveRecord::Base
    attr_accessible :domain, :name

    validates :name, :presence => true
    validates :domain, :presence => true
  end
end
