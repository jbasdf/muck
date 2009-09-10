Given /^There are blogs$/ do
  create_blogs
end

def create_blogs(blogable = nil)
  blogable ||= Factory(:user)
  blog = Factory(:blog, :blogable => blogable)
  child = Factory(:blog, :blogable => blogable)
  child.move_to_child_of(blog)
  blog
end