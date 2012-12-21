require 'test_helper'

module Xhive
  class StylesheetPresenterTest < ActiveSupport::TestCase
    setup do
      site = Site.create(:name => "default", :domain => 'localhost')
      @stylesheet = site.stylesheets.create(:name => 'test', :content => 'body { color: #fff; }')
    end

    should 'render the compressed content properly' do
      content = @stylesheet.presenter.compressed

      assert_equal "body{color:#fff}\n", content
    end

    should 'use absolute urls for the images' do
      @stylesheet.content = "body { background-image: url('/images/sample.png') }"

      assert_equal "body { background-image: url('http://localhost:3000/images/sample.png') }", @stylesheet.presenter.content
    end
  end
end

