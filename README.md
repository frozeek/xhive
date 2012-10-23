XHIVE
======

xhive is a gem built for turning your Rails application into an AJAXified CMS.

[![Build Status](https://secure.travis-ci.org/frozeek/xhive.png)](http://travis-ci.org/frozeek/xhive)
[![Code Quality](https://codeclimate.com/badge.png)](https://codeclimate.com/github/frozeek/xhive)

# How it works

xhive converts your controller actions or [cells](https://github.com/apotonick/cells) into AJAX widgets.

It leverages the power of [Liquid](http://liquidmarkup.org/) creating a custom Liquid::Tag for every
widget, so it can be called from within any HTML template.

xhive also gives you the foundation of a CMS providing the following models:

* Site
* Page
* Stylesheet
* Image

Using this models along with the xhive widgets you will be able to build a fully functional CMS.

# Installation

Add xhive to your Gemfile

`gem 'xhive'`

Run bundle install

`bundle install`

Run xhive migrations

```
rake xhive:install:migrations
rake db:migrate
```

Include the xhive javascript in your head tag.

`<%= javascript_include_tag "xhive/application" %>`

Include the custom stylesheets in your head tag.

`<%= include_custom_stylesheets %>`

Include the widgets loader just before your \<\\body\> tag.

`<%= initialize_widgets_loader %>`

# Usage

## Widgify

### Turning your controller actions into widgets

Let's say you have a Posts controller and you want to access the show action as a widget.

```
app/controller/posts_controller.rb

class PostsController < ApplicationController
  def show
    @post = Post.find(params[:id])
  end
end

app/views/posts/show.html.erb

<h1><%= @post.title %></h1>

<p><%= @post.body %></p>

config/routes.rb

resources :posts, :only => [:show]

```
Just tell xhive to *widgify* your action:

```
class PostsController < ApplicationController
  widgify :show

  def show
    @post = Post.find(params[:id])
  end
end
```
And that's it. You will now be able to insert the content of any post from within an HTML template using:

{% posts_show id:1234 %}

This tag will make the browser insert the post content asynchronously into the HTML document.

xhive will also enforce the tag to include the :id parameter.

### Using [cells](https://github.com/apotonick/cells) as reusable widgets

Let's use the same example to illustrate the use of cells with xhive.

We have a Posts cell and we want to use the show method as an AJAX widget.

```
app/cells/posts_cell.rb

class PostsCell < Cell::Rails
  def show(params)
    @post = params[:id]
    render
  end
end

app/cells/posts/show.html.erb

<div class='post'>
  <h1><%= @post.title %></h1>

  <p><%= @post.body %></p>
</div>

```
In this case, we need to tell xhive how we are mounting our widgets routes:

```
config/initializers/xhive.rb

Xhive::Router::Cells.draw do |router|
  router.mount 'posts/:id', :to => 'posts#show'
end
```

And that's it. You will now be able to insert the content of any post from within an HTML template using:

{% posts_show id:1234 %}

This tag will make the browser insert the post content asynchronously into the HTML document.

xhive will also enforce the tag to include the :id parameter.

## CMS features

Ok, I can include my cells and controller actions as widgets, but... how?

xhive provides you with some basic CMS infrastructure.

### Creating your first dynamic page

To be able to use your widgets, you have to follow the following steps:

Create a Site

```
site = Xhive::Site.create(:name => 'My awesome blog', :domain => 'localhost')
```

Create a Page

```
page = Xhive::Page.create(:name => 'home',
                          :title => 'My blog page',
                          :content => '<h1>Home</h1><p>{% posts_show id:1 %}</p>',
                          :site => site)
```

Start the server

Now you can access the page on http://localhost:3000/pages/home.

This should display the post with id: 1 inside the home page.

### Adding pages to your own custom data

You can also use the xhive pages from within you own data.

xhive provides the Xhive::Mapper to wire up your resources to xhive pages.

Create a new page to display all the posts

```
posts_page = Xhive::Page.create(:name => 'posts',
                                :title => 'Blog Posts',
                                :content => '{% for post in posts %}{% posts_show id:post.id %}{% endfor %}',
                                :site => site)
```

Create a new stylesheet to display your posts:

```
stylesheet = Xhive::Stylesheet.create(:name => 'Posts', 
                                      :content => '.post {
                                                     h1 { font-size: 20px; color: blue; }
                                                     p { font-size: 12px; color: #000; }
                                                   }',
                                      :site => site)
```

Create a new mapper record for the posts resources

```
mapper = Xhive::Mapper.create(:resource => 'posts', :action => 'index', :page => posts_page)
```

From your posts controller, render the posts page

```
class PostsController < ApplicationController
  def index
    @posts = Post.limit(10)
    render_page_with :posts => @posts
  end
end
```

Using this feature you can let the designers implement the HTML/CSS to display the posts in your site without your intervention.

TODO
====

* Implement the Image model
* Remove as many dependencies as possible
* Improve test coverage

Disclaimer
==========
This is a work in progress and still a proof of concept. Use at your own risk :P.

