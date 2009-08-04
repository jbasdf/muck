class Comment < ActiveRecord::Base
  acts_as_muck_comment
  acts_as_activity_source
  
  def after_create
    if self.commentable.is_a?(Entry)
      debugger
      # TODO only want to add this activity once
      # need logic to determin if the given entry is already in the user's activity stream.  If it is then
      # we need to bring the activity back to the top so that users see that there is action around the entry.
      # also we should do this if the user has made any comments on the activity
      add_activity(self.user.feed_to, self.user, self, 'entry', '', '')
    end
  end
  
end