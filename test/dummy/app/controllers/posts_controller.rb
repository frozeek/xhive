class PostsController < ApplicationController
  widgify :show

  def show
    @post_id = params[:id]
    @post_title = "This is a test post"
    @post_body = "This is the body of the post"
  end
end
