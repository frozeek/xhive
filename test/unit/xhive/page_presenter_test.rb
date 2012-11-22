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
  end
end

