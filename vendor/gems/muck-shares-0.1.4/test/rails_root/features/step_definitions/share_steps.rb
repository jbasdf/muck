Given /^There are shares$/ do
  create_shares
end

def create_shares(shareable = nil)
  shareable ||= Factory(:user)
  share = Factory(:share, :shareable => shareable)
  child = Factory(:share, :shareable => shareable)
  child.move_to_child_of(share)
  share
end