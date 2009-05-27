class AddPersonalRecommendations < ActiveRecord::Migration
  def self.up
	  create_table "personal_recommendations", :force => true do |t|
	      t.integer "personal_recommendable_id"
	      t.string "personal_recommendable_type"
	      t.integer "destination_id"
	      t.string "destination_type"
	      t.integer "rank"
	      t.float "relevance"
      end
  end

  def self.down
	  drop_table "personal_recommendations"
  end
end
