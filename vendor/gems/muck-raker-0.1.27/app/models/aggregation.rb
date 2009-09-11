class Aggregation < ActiveRecord::Base
  
  # ##########################################################
  # # adds a feed to an aggregation and saves the feed
  # def add_feed_to_aggregation(aggregation, feed)
  #   if aggregation.feeds.include?(feed)
  #     self.already_feeds.push(feed)
  #   else
  #     if feed.save # have to save here so that feed has an id.  Without id can't associate with aggregation
  #       feed.aggregations << aggregation
  #       self.added_feeds.push(feed )
  #     end
  #   end
  #   feed.save
  # end

end