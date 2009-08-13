# == Schema Information
#
# Table name: shares
#
#  id            :integer(4)      not null, primary key
#  uri           :string(2083)    default(""), not null
#  title         :string(255)
#  message       :text
#  shared_by_id  :integer(4)      not null
#  created_at    :datetime
#  updated_at    :datetime
#  comment_count :integer(4)      default(0)
#  entry_id      :integer(4)
#
# Indexes
#
#  index_shares_on_shared_by_id  (shared_by_id)
#  index_shares_on_uri           (uri)
#

class Share < ActiveRecord::Base
  acts_as_muck_share
  belongs_to :entry
end
