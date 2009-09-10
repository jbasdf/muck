Given /^There are comments$/ do
  create_comments
end

def create_comments(commentable = nil)
  commentable ||= Factory(:user)
  comment = Factory(:comment, :commentable => commentable)
  child = Factory(:comment, :commentable => commentable)
  child.move_to_child_of(comment)
  comment
end