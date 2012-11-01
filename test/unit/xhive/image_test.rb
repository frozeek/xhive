require 'test_helper'

module Xhive
  class ImageTest < ActiveSupport::TestCase
    should validate_presence_of(:image)
    should validate_presence_of(:site)

    should 'return the base name' do
      image = Image.new
      image.stubs(:image).returns("/public/images/test.png")

      assert_equal image.basename, 'test.png'
    end
  end
end
