require 'test_helper'

module Xhive
  class ApplicationHelperTest < ActionView::TestCase
    CURRENT_SITE = Hashy.new(:id => 1)

    class Sample
      include ApplicationHelper

      attr :action_name

      def current_site
        CURRENT_SITE
      end

      def controller_path
        'sample'
      end

      def render(opts={})
        opts[:inline] || "static template"
      end

      def index
        @action_name = 'index'
        render_page_with 'my_key', :user => "the user", :product => "the product"
      end

      def show
        @action_name = 'show'
        render_page_with 'my_key', :user => "the user", :product => "the product" do
          "my block"
        end
      end
    end

    def setup
      @options = { :user => "the user", :product => "the product" }
      @page = Hashy.new(:present_content => 'dynamic content', :present_title => 'dynamic subject')
    end

    context 'render page with' do
      should 'render the page content' do
        Xhive::Mapper.expects(:page_for).with(CURRENT_SITE, 'sample', 'index', 'my_key', @options).returns(@page)
        sample = Sample.new
        assert_equal 'dynamic content', sample.index
      end

      should 'render the static template' do
        Xhive::Mapper.expects(:page_for).with(CURRENT_SITE, 'sample', 'index', 'my_key', @options).returns(nil)
        sample = Sample.new
        assert_equal 'static template', sample.index
      end

      should 'yield the render block' do
        Xhive::Mapper.expects(:page_for).with(CURRENT_SITE, 'sample', 'show', 'my_key', @options).returns(nil)
        sample = Sample.new
        assert_equal 'my block', sample.show
      end
    end
  end
end
