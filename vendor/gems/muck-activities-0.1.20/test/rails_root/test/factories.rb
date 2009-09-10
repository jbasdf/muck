Factory.sequence :email do |n|
  "somebody#{n}@example.com"
end

Factory.sequence :login do |n|
  "inquire#{n}"
end

Factory.sequence :name do |n|
  "a_name#{n}"
end

Factory.sequence :title do |n|
  "a_title#{n}"
end

Factory.sequence :abbr do |n|
  "abbr#{n}"
end

Factory.sequence :description do |n|
  "This is the description: #{n}"
end

Factory.define :user do |f|
  f.login { Factory.next(:login) }
  f.email { Factory.next(:email) }
  f.password 'inquire_pass'
  f.password_confirmation 'inquire_pass'
  f.first_name 'test'
  f.last_name 'guy'
  f.terms_of_service true
  f.activated_at DateTime.now
end

Factory.define :activity do |f|
  f.item {|a| a.association(:user)}
  f.template ''
  f.source {|a| a.association(:user)}
  f.content ''
  f.title ''
  f.is_status_update false
  f.is_public true
  f.created_at DateTime.now
end

Factory.define :comment do |f|
  f.body 'test comment'
  f.user {|a| a.association(:user)}
end

Factory.define :share do |f|
  f.uri { Factory.next(:uri) }
  f.title { Factory.next(:title) }
  f.shared_by {|a| a.association(:user)}
end

Factory.sequence :uri do |n|
  "n#{n}.example.com"
end
