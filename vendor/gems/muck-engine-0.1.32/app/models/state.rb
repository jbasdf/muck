# == Schema Information
#
# Table name: states
#
#  id           :integer         not null, primary key
#  name         :string(128)     default(""), not null
#  abbreviation :string(3)       default(""), not null
#  country_id   :integer(8)      not null
#

class State < ActiveRecord::Base
  belongs_to :country
end
