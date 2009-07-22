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

Factory.sequence :uri do |n|
  "n#{n}.example.com"
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

Factory.define :content_page do |f|
  f.creator {|a| a.association(:user)}
  f.title { Factory.next(:name) }
  f.body_raw { Factory.next(:description) }
end

Factory.define :permission do |f|
  f.role {|a| a.association(:role)}
  f.user {|a| a.association(:user)}
end

Factory.define :role do |f|
  f.rolename 'administrator'
end

Factory.define :comment do |f|
  f.body { Factory.next(:name) }
  f.user {|a| a.association(:user)}
end

Factory.define :domain_theme do |f|
  f.name { Factory.next(:name) }
  f.uri { Factory.next(:uri) }
end

Factory.define :theme do |f|
  f.name { Factory.next(:name) }
end

Factory.define :feed do |f|
  f.contributor { |a| a.association(:user) }
  f.uri { Factory.next(:uri) }
  f.display_uri { Factory.next(:uri) }
  f.title { Factory.next(:title) }
  f.short_title { Factory.next(:title) }
  f.description { Factory.next(:description) }
  f.top_tags { Factory.next(:name) }
  f.priority 1
  f.status 1
  f.last_requested_at DateTime.now
  f.last_harvested_at DateTime.now
  f.harvest_interval 86400
  f.failed_requests 0
  f.harvested_from_display_uri { Factory.next(:uri) }
  f.harvested_from_title { Factory.next(:title) }
  f.harvested_from_short_title { Factory.next(:title) }
  f.entries_count 0
  f.default_language { |a| a.association(:language) }
  f.default_grain_size 'unknown'
end

Factory.define :entry do |f|
  f.feed { |a| a.association(:feed) }
  f.permalink { Factory.next(:uri) }
  f.author { Factory.next(:name) }
  f.title { Factory.next(:title) }
  f.description { Factory.next(:description) }
  f.content { Factory.next(:description) }
  f.unique_content { Factory.next(:description) }
  f.published_at DateTime.now
  f.entry_updated_at DateTime.now
  f.harvested_at DateTime.now
  f.language { |a| a.association(:language) }
  f.direct_link { Factory.next(:uri) }
  f.grain_size 'unknown'
end


Factory.define :content do |f|
  f.creator { |a| a.association(:user) }
  f.title { Factory.next(:title) }
  f.body_raw { Factory.next(:description) }
  f.is_public true
  f.locale 'en'
end

Factory.define :content_translation do |f|
  f.content { |a| a.association(:content) }
  f.title { Factory.next(:title) }
  f.body { Factory.next(:description) }
  f.locale 'en'
end

Factory.define :content_permission do |f|
  f.content { |a| a.association(:content) }
  f.user {|a| a.association(:user)}
end
