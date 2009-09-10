# == Schema Information
#
# Table name: comments
#
#  id               :integer(4)      not null, primary key
#  commentable_id   :integer(4)      default(0)
#  commentable_type :string(15)      default("")
#  body             :text
#  user_id          :integer(4)
#  parent_id        :integer(4)
#  lft              :integer(4)
#  rgt              :integer(4)
#  is_denied        :integer(4)      default(0), not null
#  is_reviewed      :boolean(1)
#  created_at       :datetime
#  updated_at       :datetime
#

require File.dirname(__FILE__) + '/../test_helper'

class CommentTest < ActiveSupport::TestCase

  context "comment instance" do
  
    context "activities" do
      setup do
        @entry = Factory(:entry)
        @user = Factory(:user)
      end
      should "add comment activity" do
        assert_difference "Activity.count", 1 do
          Comment.create(Factory.attributes_for(:comment, :commentable => @entry, :user => @user))
        end
      end
    end
  end
  
end
