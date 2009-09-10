class ChangeTagCloudGrainSizes < ActiveRecord::Migration
  def self.up
    execute "update tag_clouds set grain_size = 'all' where grain_size = 'unknown'"
  end

  def self.down
    execute "update tag_clouds set grain_size = 'unknown' where grain_size = 'all'"
  end
end
