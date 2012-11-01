require 'test_helper'

module Xhive
  class ImageTest < ActiveSupport::TestCase
    should validate_presence_of(:image)
    should validate_presence_of(:site)
  end
end
