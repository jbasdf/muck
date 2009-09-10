# == Schema Information
#
# Table name: clicks
#
#  id                :integer(4)      not null, primary key
#  recommendation_id :integer(4)
#  when              :datetime        not null
#  referrer          :string(2083)
#  requester         :string(255)
#  user_agent        :string(2083)
#

class Click < ActiveRecord::Base
end
