Factory.sequence :email do |n|
  "somebody#{n}@example.com"
end

Factory.sequence :login do |n|
  "inquire#{n}"
end

Factory.sequence :name do |n|
  "a_name#{n}"
end

Factory.sequence :abbr do |n|
  "abbr#{n}"
end

Factory.sequence :description do |n|
  "This is the description: #{n}"
end

Factory.define :state do |f|
  f.name { Factory.next(:name) }
  f.abbreviation { Factory.next(:abbr) }
  f.country {|a| a.association(:country) }
end

Factory.define :country do |f|
  f.name { Factory.next(:name) }
  f.abbreviation { Factory.next(:abbr) }
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

Factory.define :permission do |f|
  f.role {|a| a.association(:role)}
  f.user {|a| a.association(:user)}
end

Factory.define :role do |f|
  f.rolename 'administrator'
end
