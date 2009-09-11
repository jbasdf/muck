# == Schema Information
#
# Table name: attentions
#
#  id                 :integer(4)      not null, primary key
#  attentionable_id   :integer(4)
#  attentionable_type :string(255)
#  entry_id           :integer(4)
#  action_type        :string(255)
#  weight             :float
#

class Attention < ActiveRecord::Base
end
