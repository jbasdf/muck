# == Schema Information
#
# Table name: tag_clouds
#
#  id          :integer(4)      not null, primary key
#  language_id :integer(4)
#  filter      :string(255)
#  tag_list    :string(5000)
#  grain_size  :string(255)     default("all")
#

require File.dirname(__FILE__) + '/../test_helper'

# Used to test muck_content_translation
class TagCloudTest < ActiveSupport::TestCase

  context "A tag cloud instance" do
    should "get cached tag cloud" do
      #self.language_tags language_id = 38, grain_size = 'all', filter = ''
    end
  end
  
end
