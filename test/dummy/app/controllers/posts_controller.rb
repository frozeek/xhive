class PostsController < ApplicationController
  widgify :show

  def show
    @post = Post.new(:id => params[:id], :title => "The day of the whale", :body => "This is great to be able to write")
    render_page_with :post => @post
  end
end
