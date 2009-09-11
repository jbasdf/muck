# == Schema Information
#
# Table name: countries
#
#  id           :integer         not null, primary key
#  name         :string(128)     default(""), not null
#  abbreviation :string(3)       default(""), not null
#  sort         :integer         default(1000), not null
#

class Country < ActiveRecord::Base
  
end
