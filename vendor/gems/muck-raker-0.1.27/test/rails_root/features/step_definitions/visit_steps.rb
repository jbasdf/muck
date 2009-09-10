Given /^There is an entry in the database$/ do
  entry = Entry.first
  if entry.nil?
    entry = Factory(:entry)
  end
end