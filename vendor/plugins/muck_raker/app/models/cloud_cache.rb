class CloudCache < ActiveRecord::Base
  
  def self.language_tags language
    CloudCache.find_by_sql("SELECT tag_list FROM cloud_caches WHERE language_id = 38 AND filter = 'all'").first.tag_list
  end
  
end
