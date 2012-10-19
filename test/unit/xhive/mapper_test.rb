require 'test_helper'

module Xhive
  class MapperTest < ActiveSupport::TestCase
    should validate_presence_of(:site)
    should validate_presence_of(:page)
    should validate_presence_of(:resource)
    should validate_presence_of(:action)
  end
end
