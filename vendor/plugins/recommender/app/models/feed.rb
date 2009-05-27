class Feed < ActiveRecord::Base
  has_many :entries
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
  
end
