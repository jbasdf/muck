# require 'httparty'

class Feed < ActiveRecord::Base
  
  # include HTTParty
  # format :xml
  
  has_many :entries
  
  # named_scope :ready_to_harvest, lambda { |*args| { :conditions => [ "feeds.last_harvested_at < ?", args.first || 1.day.ago.end_of_day ] } }
                                                                        
  def refresh_interval_hours
    if self.harvest_interval
      self.harvest_interval.split(':')[0]
    else
        "168"
    end
  end
  
  def refresh_interval_hours=(interval)
    self.harvest_interval = interval + ":00:00"
  end
  
  # def self.harvest
  #   feed = Feed.first # .ready_to_harvest.first
  #   get(feed.uri)
  # end
  
end
