class Post < ActiveRecord::Base
  attr_accessible :body, :title

  liquid_methods :title, :body

  mount_page :page
end
