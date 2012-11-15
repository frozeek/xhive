require 'test_helper'

class PageCellTest < Cell::TestCase
  setup do
    @site = Xhive::Site.create(:name => "Test", :domain => 'localhost')
    @page = Xhive::Page.create(:name => "Cell Page", :title => "Cell Page", :content => "<h1>{{page_title}}</h1>", :site_id => @site.id)
  end

  context 'inline rendering' do
    should 'render the page content with all the params' do
      result = render_cell('xhive/page', :inline, :id => @page.id, :page_title => "Hello World")
      assert_equal '<h1>Hello World</h1>', result
    end
  end
end
