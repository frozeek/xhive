require 'test_helper'

module Xhive
  class StylesheetTest < ActiveSupport::TestCase
    should validate_presence_of(:name)
    should validate_uniqueness_of(:name).scoped_to(:site_id)
    should validate_presence_of(:content)
    should validate_presence_of(:site)

    should 'be searchable by name' do
      site = Site.create(:name => "default")
      stylesheet = Stylesheet.create(:name => "default", :content => "body {}", :site => site)

      assert_equal Stylesheet.find('default'), stylesheet
    end

    should 'check CSS syntax' do
      site = Site.create(:name => "default")
      stylesheet = Stylesheet.new(:name => 'test', :content => 'body { color: #fff; }', :site => site)
      assert stylesheet.valid?, 'stylesheet should be valid'

      stylesheet.content = 'this is not css'

      assert !stylesheet.valid?, 'stylesheet should not be valid'
      assert stylesheet.errors.include?(:content)
      assert stylesheet.errors[:content].first =~ /Invalid CSS/, 'stylesheet content should say invalid css syntax'
    end
  end
end
