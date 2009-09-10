# == Schema Information
#
# Table name: tag_clouds
#
#  id          :integer(4)      not null, primary key
#  language_id :integer(4)
#  filter      :string(255)
#  tag_list    :string(5000)
#  grain_size  :string(255)     default("all")
#

class TagCloud < ActiveRecord::Base
  
  # Get a tag cloud for the given language
  # HACK language_id = 38 is english
  def self.language_tags(language_id = 38, grain_size = 'all', filter = '')
    cloud = TagCloud.find(:first, :conditions => ["language_id = ? AND grain_size = ? AND filter = ? ", language_id, grain_size, filter.sort.join('/')])
    cloud.nil? ? '' : cloud.tag_list
  end
  
end
