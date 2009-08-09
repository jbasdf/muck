class Comment < ActiveRecord::Base
  acts_as_muck_comment
  acts_as_activity_source
  
  def after_create
    # Only add activity entries for specific kinds of comments.  Otherwise the comments could show up multiple times.  
    # Comments are attached to items in the feed.  If you add an activity entry for each new comment it will show 
    # up as a top level item in the feed as well as under the item that is in the feed.
    if self.commentable.is_a?(Entry) # An entry doesn't automatically show up in the activity feed so 
      debugger
      add_activity(self.user.feed_to, self.user, self, 'entry', '', '')
    end
  end
  
end