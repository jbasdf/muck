# == Schema Information
#
# Table name: blogs
#
#  id            :integer(4)      not null, primary key
#  blogable_id   :integer(4)      default(0)
#  blogable_type :string(255)     default("")
#  title         :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_blogs_on_blogable_id_and_blogable_type  (blogable_id,blogable_type)
#

class Blog < ActiveRecord::Base
  acts_as_muck_blog
end
