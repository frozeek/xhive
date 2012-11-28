require 'test_helper'

module Xhive
  class SamplePolicy
    def self.call(attrs={})
      attrs[:name] == "John" && attrs[:age] > 18
    end
  end

  class InvalidPolicy; end

  class MapperTest < ActiveSupport::TestCase
    should validate_presence_of(:site)
    should validate_presence_of(:page)
    should validate_presence_of(:resource)
    should validate_presence_of(:action)

    setup do
      @site = Site.create(:name => "default", :domain => 'localhost')
      @page = @site.pages.create(:name => "page", :title => "Specific Page", :content => "<h1>Hello Specific World</h1>")
      Xhive::Mapper.map_resource(@site, @page, 'my_resource', 'my_action', 'my_key')
    end

    context 'page for' do
      setup do
        @default_page = @site.pages.create(:name => "default", :title => "Default Page", :content => "<h1>Hello World</h1>")
        Xhive::Mapper.map_resource(@site, @default_page, 'my_resource', 'my_action')
      end

      context 'using a plain text key' do
        should 'return a valid page if mapper exists' do
          assert_equal @page, Xhive::Mapper.page_for(@site, 'my_resource', 'my_action', 'my_key')
        end

        should 'return the default page if mapper does not exist' do
          assert_equal @default_page, Xhive::Mapper.page_for(@site, 'my_resource', 'my_action', 'my')
        end

        should 'return nil if default mapper does not exist' do
          assert_equal nil, Xhive::Mapper.page_for(@site, 'my_non_existing', 'no_action', 'my')
        end
      end

      context 'using a policy filtered mapper' do
        setup do
          @policy_page = @site.pages.create(:name => "policy", :title => "Policy Page", :content => "<h1>Hello Policy Page</h1>")
          Xhive::Mapper.map_resource(@site, @policy_page, 'my_resource', 'my_action', nil, "Xhive::SamplePolicy")
        end

        should 'return the policy page if the policy matches' do
          assert_equal @policy_page, Xhive::Mapper.page_for(@site, 'my_resource', 'my_action', nil, { :name => "John", :age => 20 })
        end

        should 'return the default page if the policy does not match' do
          assert_equal @default_page, Xhive::Mapper.page_for(@site, 'my_resource', 'my_action', nil, { :name => "Rick", :age => 15 })
        end
      end

      context 'using a wrong policy class' do
        should 'raise an error if policy class does not exist' do
          assert_raise NameError do
            Xhive::Mapper.map_resource(@site, @page, 'my_resource', 'my_action', nil, "Xhive::Undefined")
          end

          assert_raise Xhive::Mapper::InvalidPolicyError do
            Xhive::Mapper.map_resource(@site, @page, 'my_resource', 'my_action', nil, "Xhive::InvalidPolicy")
          end
        end
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
