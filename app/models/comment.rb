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
  acts_as_activity_source
  
  # TODO this should probably be moved into an observer as it doesn't realy have anything to do with comments and instead
  # is here because entries, being added by the aggregator, don't already have an activity entry.
  # def after_create
  #   # Only add activity entries for specific kinds of comments.  Otherwise the comments could show up multiple times.  
  #   # Comments are attached to items in the feed.  If you add an activity entry for each new comment it will show 
  #   # up as a top level item in the feed as well as under the item that is in the feed.
  #   if self.commentable.is_a?(Entry) # An entry doesn't automatically show up in the activity feed so 
  #     debugger
        # Add an activity for the given entry unless one already exists
  #     add_activity(self.user.feed_to, self.user, self, 'entry', '', '')
  #   end
  # end
  
  # Another big TODO.  Need a way to bring activity entries back to the top when a new comment is added or at least some mechanism for drawing 
  # attention to the event.  Look at how facebook handles this.
end
