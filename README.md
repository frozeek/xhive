XHIVE
======

xhive is a gem built for turning your Rails application into an AJAXified CMS.

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

xhive is a gem and is also a Rails Engine. Just add it to your Gemfile and you will be good to go.

`gem 'xhive'`

# Usage

## Turning your controller actions into widgets

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

## Using [cells](https://github.com/apotonick/cells) as reusable widgets

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

<h1><%= @post.title %></h1>

<p><%= @post.body %></p>

```
In this case, we need to tell xhive how we are mounting our widgets routes:

```
config/initializers/xhive.rb

XHive::Routes.draw do |router|
  router.mount 'posts/:id', :to => 'posts#show'
end
```

And that's it. You will now be able to insert the content of any post from within an HTML template using:

{% posts_show id:1234 %}

This tag will make the browser insert the post content asynchronously into the HTML document.

xhive will also enforce the tag to include the :id parameter.

Disclaimer
==========
This is a work in progress and still a proof of concept. Use at your own risk :P.
