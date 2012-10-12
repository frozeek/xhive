require 'test_helper'

module Xhive
  class SiteTest < ActiveSupport::TestCase
    should validate_presence_of(:name)
    should validate_presence_of(:domain)
  end
end
