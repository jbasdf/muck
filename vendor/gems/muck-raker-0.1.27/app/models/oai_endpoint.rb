# == Schema Information
#
# Table name: oai_endpoints
#
#  id              :integer(4)      not null, primary key
#  uri             :string(2083)
#  display_uri     :string(2083)
#  metadata_prefix :string(255)
#  title           :string(1000)
#  short_title     :string(100)
#

class OaiEndpoint < ActiveRecord::Base
end
