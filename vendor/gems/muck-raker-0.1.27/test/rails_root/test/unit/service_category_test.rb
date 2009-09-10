# == Schema Information
#
# Table name: service_categories
#
#  id   :integer(4)      not null, primary key
#  name :string(255)     not null
#  sort :integer(4)      default(0)
#

require File.dirname(__FILE__) + '/../test_helper'

class ServiceCategoryTest < ActiveSupport::TestCase

  context "service category instance" do
    should_have_many :services
    should_have_named_scope :sorted
  end
  
end
