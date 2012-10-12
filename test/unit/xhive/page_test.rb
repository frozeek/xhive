require 'test_helper'

module Xhive
  class PageTest < ActiveSupport::TestCase
    should validate_presence_of(:name)
    should validate_presence_of(:title)
    should validate_presence_of(:content)

    should 'be searchable by name' do
      page = Page.create(:name => "default", :title => "Default Page", :content => "<h1>Hello World</h1>")

      assert_equal Page.find('default'), page
    end
  end
end
