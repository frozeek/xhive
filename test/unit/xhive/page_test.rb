require 'test_helper'

module Xhive
  class PageTest < ActiveSupport::TestCase
    should validate_presence_of(:name)
    should validate_uniqueness_of(:name).scoped_to(:site_id)
    should validate_presence_of(:title)
    should validate_presence_of(:content)
    should validate_presence_of(:site)

    should 'be searchable by name' do
      site = Site.create(:name => "default", :domain => 'localhost')
      page = site.pages.create(:name => "default", :title => "Default Page", :content => "<h1>Hello World</h1>")

      assert_equal Page.find('default'), page
    end
  end
end
