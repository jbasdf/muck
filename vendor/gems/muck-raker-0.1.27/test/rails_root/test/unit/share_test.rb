# == Schema Information
#
# Table name: shares
#
#  id            :integer(4)      not null, primary key
#  uri           :string(2083)    default(""), not null
#  title         :string(255)
#  message       :text
#  shared_by_id  :integer(4)      not null
#  shared_to_id  :integer(4)
#  created_at    :datetime
#  updated_at    :datetime
#  entry_id      :integer(4)
#  comment_count :integer(4)      default(0)
#

require File.dirname(__FILE__) + '/../test_helper'

class ShareTest < ActiveSupport::TestCase

  context "share instance" do
    setup do
      @share = Factory(:share)
    end
    should_belong_to :entry
    should "return entry for discover_attach_to" do
      assert_equal @share.entry, @share.discover_attach_to
    end
  end
  
end
