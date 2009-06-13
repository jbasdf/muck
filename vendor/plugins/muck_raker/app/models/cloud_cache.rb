class CloudCache < ActiveRecord::Base
  
  def self.language_tags language
    english_id = 38
    results = CloudCache.find(:all, :conditions => ["language_id = ? AND filter = 'all'", english_id])
    results.empty? ? '' : results[0].tag_list
  end
  
end
