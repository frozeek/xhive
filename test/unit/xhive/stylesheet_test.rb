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
  end
end
