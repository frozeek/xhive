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

```bash
rake xhive:install:migrations
rake db:migrate
```

Include the xhive javascript loader in your head tag.

```erb
<%= javascript_include_tag "xhive/loader" %>
```

Include the custom stylesheets in your head tag.

```erb
<%= include_custom_stylesheets %>
```

Include the widgets loader just before your \<\\body\> tag.

```erb
<%= initialize_widgets_loader %>
```

# Usage

## Widgify

### Turning your controller actions into widgets

Let's say you have a Posts controller and you want to access the show action as a widget.

`app/controller/posts_controller.rb`

```ruby
class PostsController < ApplicationController
  def show
    @post = Post.find(params[:id])
  end
end
```

`app/views/posts/show.html.erb`

```erb
<h1><%= @post.title %></h1>

<p><%= @post.body %></p>
```

`config/routes.rb`

```ruby
resources :posts, :only => [:show]
```

Just tell xhive to *widgify* your action:

```ruby
class PostsController < ApplicationController
  widgify :show

  def show
    @post = Post.find(params[:id])
  end
end
```

And that's it. You will now be able to insert the content of any post from within an HTML template using:

`{% posts_show id:1234 %}`

This tag will make the browser insert the post content asynchronously into the HTML document.

xhive will also enforce the tag to include the :id parameter.

### Using [cells](https://github.com/apotonick/cells) as reusable widgets

Let's use the same example to illustrate the use of cells with xhive.

We have a Posts cell and we want to use the show method as an AJAX widget.

`app/cells/posts_cell.rb`

```ruby
class PostsCell < Cell::Rails
  def show(params)
    @post = params[:id]
    render
  end
end
```

`app/cells/posts/show.html.erb`

```erb
<div class='post'>
  <h1><%= @post.title %></h1>

  <p><%= @post.body %></p>
</div>
```

In this case, we need to tell xhive how we are mounting our widgets routes:

`config/initializers/xhive.rb`

```ruby
Xhive::Router::Cells.draw do |router|
  router.mount 'posts/:id', :to => 'posts#show'
end
```

And that's it. You will now be able to insert the content of any post from within an HTML template using:

`{% posts_show id:1234 %}`

This tag will make the browser insert the post content asynchronously into the HTML document.

xhive will also enforce the tag to include the :id parameter.

You can customize the tag invocation name by using the :as symbolized option:

```ruby
Xhive::Router::Cells.draw do |router|
  router.mount 'posts/:id', :to => 'posts#show', :as => 'show_post'
end
```
Then you can insert the tag using the following snippet:

`{% show_post id:1234 %}`

You can also force the cell widget to be rendered inline instead of using AJAX.

Just include the :inline symbolized option:

```ruby
Xhive::Router::Cells.draw do |router|
  router.mount 'posts/:id', :to => 'posts#show', :as => 'show_post', :inline => true
end
```

This is also useful when using stylesheet tags inside email pages.

Caveat: the inline feature only works for Cell:Base cells.

## CMS features

Ok, I can include my cells and controller actions as widgets, but... how?

xhive provides you with some basic CMS infrastructure.

### Creating your first dynamic page

To be able to use your widgets, you have to follow the following steps:

Create a Site

```ruby
site = Xhive::Site.create(:name => 'My awesome blog', :domain => 'localhost')
```

Create a Page

```ruby
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

```ruby
posts_page = Xhive::Page.create(:name => 'posts',
                                :title => 'Blog Posts',
                                :content => '{% for post in posts %}{% posts_show id:post.id %}{% endfor %}',
                                :site => site)
```

Create a new stylesheet to display your posts:

```ruby
stylesheet = Xhive::Stylesheet.create(:name => 'Posts', 
                                      :content => '.post {
                                                     h1 { font-size: 20px; color: blue; }
                                                     p { font-size: 12px; color: #000; }
                                                   }',
                                      :site => site)
```

Create a new mapper record for the posts resources

```ruby
mapper = Xhive::Mapper.map_resource(site, posts_page, 'posts', 'index')
```

If you want to map the page to a specific post

```ruby
mapper = Xhive::Mapper.map_resource(site, posts_page, 'posts', 'index', post.id)
```

From your posts controller, render the posts page

```ruby
class PostsController < ApplicationController
  # This will render the page associated with the index action
  def index
    @posts = Post.limit(10)
    render_page_with :posts => @posts
  end

  # This will render the page associated with the specific post
  def show
    @post = Post.find(params[:id])
    render_page_with @post.id, :post => @post
  end
end
```

Using this feature you can let the designers implement the HTML/CSS to display the posts in your site without your intervention.

## Policy based mapping

If you need more customization in the page mapping process, you can pass a policy class name as the last attribute.

```ruby
class MyPolicyClass
  def call(opts={})
    opts[:user].country == 'US' && opts[:user].age > 18
  end
end

mapper = Xhive::Mapper.map_resource(site, posts_page, 'posts', 'index', post.id, 'MyPolicyClass')

# It will only use the page if the user is an adult from the US
render_page_with @post.id, :post => @post, :user => @user

```
Note: the mailer instance variables will be passed along to the policy class. This allows you to customize the email templates
depending on the user properties. See below for ActionMailer integration.

## ActionMailer integration

Using xhive you can extend the CMS capabilities to your system generated emails.

```ruby
class Notifications < ActionMailer::Base
  def welcome(site, user)
    @user = user
    @link = root_url

    mailer = Xhive::Mailer.new(site, self)
    mailer.send :to => user.email, :subject => 'Welcome!'
  end
end
```
In order to use this, you must create a mapper for this specific email action:

```ruby
mapper = site.mappers.new(:resource => 'notifications', :action => 'welcome')
mapper.page = my_awesome_email_page
mapper.save
```

You can use your instance variables from within the dynamic page:

```
<p>Dear {{user.first_name}}</p>

<p>Welcome to our awesome site</p>

<p>Click <a href='{{link}}'>here</a> to start!</p>

```

If you want to use different pages for different, e.g. user categories, you can pass the user category to the mailer initializer:

```ruby
mailer = Xhive::Mailer.new(site, self, user.category)
```

And you add the key to the mapper creation step:

```ruby
mapper = site.mappers.new(:resource => 'notifications', :action => 'welcome', :key => 'spanish')
mapper.page = email_for_spanish_users
mapper.save
```

Note: the page title will be used as the email subject. You can also make use of the instance variables
inside the page title as is treated as a Liquid template string.

### Inline stylesheets for your emails

If you add the inline widget to your cell routes you can use inline stylesheets within your email pages:

```ruby
Xhive::Router::Cells.draw do |router|
  router.mount 'stylesheet/:id', :to => 'xhive/stylesheet#inline', :inline => true, :as => :inline_stylesheet
end
```

Then you can add your stylesheet into your email page using the corresponding tag:

`{% inline_stylesheet id:spain_users_stylesheet %}`

This will create a `<style>` tag inside your email page and inject all the style rules.

### Inline pages for your emails

If you add the inline widget to your cell routes you can use inline pages within your email pages:

```ruby
Xhive::Router::Cells.draw do |router|
  router.mount 'page/:id', :to => 'xhive/page#inline', :inline => true, :as => :inline_page
end
```

Then you can add your inline page into your email page using the corresponding tag:

`{% inline_page id:email_header %}`

## TODO

* Remove as many dependencies as possible
* Improve test coverage

## Disclaimer

This is a work in progress and still a proof of concept. Use at your own risk.

Please let me know of any problems, ideas, improvements, etc.

## Special Thanks

* Thanks to [Daniel Cadenas](https://github.com/dcadenas) for the Policy class inspiration.
