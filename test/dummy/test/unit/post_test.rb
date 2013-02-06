require 'test_helper'

class PostTest < ActiveSupport::TestCase
  setup do
    @site = Xhive::Site.create(:name => "default", :domain => 'localhost')
    @page = @site.pages.create(:name => "page", :title => "Specific Page", :content => "<h1>{{post.title}}</h1>{{post.body}}<a href='{{link}}'></a>")
  end

  context 'mount page' do
    should 'be able to assign and retrieve a page' do
      @post = Post.create(:title => "My Post", :body => '<h1>Hello World</h1>')
      @post.page = @page

      @post.reload

      assert_equal @page, @post.page
    end

    should 'be able to render page content' do
      @post = Post.create(:title => "My Post", :body => '<p>Hello World</p>')
      @post.page = @page
      @post.reload

      assert_equal "<h1>My Post</h1><p>Hello World</p><a href='www.hello.com'></a>", @post.page_content(:link => 'www.hello.com')
    end

    should 'raise an error if the post is not persisted' do
      @post = Post.new(:title => "My Post", :body => '<h1>Hello World</h1>')
      assert_raise Xhive::ActiveRecordExtensions::RecordNotPersistedError do @post.page = @page end
    end
  end
end
