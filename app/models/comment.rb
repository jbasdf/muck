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
# Indexes
#
#  index_comments_on_user_id                              (user_id)
#  index_comments_on_commentable_id_and_commentable_type  (commentable_id,commentable_type)
#

class Comment < ActiveRecord::Base
  acts_as_muck_comment
  acts_as_muck_services_comment
  acts_as_activity_item
end
