require 'test_helper'

module Xhive
  class PagePresenterTest < ActiveSupport::TestCase
    setup do
      site = Site.create(:name => "default", :domain => 'localhost')
      @page = site.pages.create(:name => "default", :title => "Default Page for {{user}}", :content => "<h1>Hello {{thing}}</h1>")
    end

    should 'render the content properly' do
      content = @page.presenter.render_content(:thing => 'World')

      assert_equal content, "<h1>Hello World</h1>"
    end

    should 'render the title properly' do
      title = @page.presenter.render_title(:user => 'John')

      assert_equal title, "Default Page for John"
    end

    should 'use absolute urls for the images' do
      @page.content = "<img src='/images/sample.png'/>"

      assert_equal "<img src='//localhost:3000/images/sample.png'/>", @page.presenter.render_content
    end

    should 'remove the port 80' do
      opts = BasePresenter.default_url_options
      BasePresenter.default_url_options = { :host => 'localhost', :port => '80' }

      @page.content = "<img src='/images/sample.png'/>"

      assert_equal "<img src='//localhost/images/sample.png'/>", @page.presenter.render_content

      BasePresenter.default_url_options = opts
    end
  end
end

