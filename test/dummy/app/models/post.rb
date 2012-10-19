class Post
  attr :title, :body

  liquid_methods :title, :body

  def initialize(attrs={})
    @id = attrs[:id]
    @title = attrs[:title]
    @body = attrs[:body]
  end
end
