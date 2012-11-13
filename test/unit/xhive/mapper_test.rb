require 'test_helper'

module Xhive
  class MapperTest < ActiveSupport::TestCase
    should validate_presence_of(:site)
    should validate_presence_of(:page)
    should validate_presence_of(:resource)
    should validate_presence_of(:action)

    setup do
      @site = Site.create(:name => "default", :domain => 'localhost')
      @page = @site.pages.create(:name => "default", :title => "Default Page", :content => "<h1>Hello World</h1>")
      @mapper = @site.mappers.create(:resource => 'my_resource', :action => 'my_action', :key => 'my_key', :page_id => @page.id)
    end

    context 'page for' do
      should 'return a valid page if mapper exists' do
        assert_equal @page, Xhive::Mapper.page_for(@site, 'my_resource', 'my_action', 'my_key')
      end

      should 'return nil if mapper does not exist' do
        assert_equal nil, Xhive::Mapper.page_for(@site, 'my_resource', 'my_action', 'my')
      end
    end

    context 'map resource' do
      should 'create a new mapper if it does not exist' do
        Xhive::Mapper.map_resource(@site, @page, 'new_resource', 'my_action')

        assert_equal 2, Xhive::Mapper.count
        assert_equal @page, Xhive::Mapper.page_for(@site, 'new_resource', 'my_action')
      end

      should 'update the mapper if it already exists' do
        assert_equal @page, Xhive::Mapper.page_for(@site, 'my_resource', 'my_action', 'my_key')

        new_page = @site.pages.create(:name => "New Page", :title => "New Page", :content => "<h1>I am new</h1>")

        Xhive::Mapper.map_resource(@site, new_page, 'my_resource', 'my_action', 'my_key')

        assert_equal 1, Xhive::Mapper.count
        assert_equal new_page, Xhive::Mapper.page_for(@site, 'my_resource', 'my_action', 'my_key')
      end
    end
  end
end
