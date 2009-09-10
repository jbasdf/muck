# == Schema Information
#
# Table name: entries
#
#  id                      :integer(4)      not null, primary key
#  feed_id                 :integer(4)      not null
#  permalink               :string(2083)    default(""), not null
#  author                  :string(2083)
#  title                   :text            default(""), not null
#  description             :text
#  content                 :text
#  unique_content          :boolean(1)
#  published_at            :datetime        not null
#  entry_updated_at        :datetime
#  harvested_at            :datetime
#  oai_identifier          :string(2083)
#  language_id             :integer(4)
#  direct_link             :string(2083)
#  indexed_at              :datetime        default(Fri Jan 01 01:01:01 UTC 1971), not null
#  relevance_calculated_at :datetime        default(Fri Jan 01 01:01:01 UTC 1971), not null
#  popular                 :text
#  relevant                :text
#  other                   :text
#  grain_size              :string(255)     default("unknown")
#
# Indexes
#
#  index_entries_on_direct_link              (direct_link)
#  index_entries_on_feed_id                  (feed_id)
#  index_entries_on_indexed_at               (indexed_at)
#  index_entries_on_language_id              (language_id)
#  index_entries_on_oai_identifier           (oai_identifier)
#  index_entries_on_permalink                (permalink)
#  index_entries_on_published_at             (published_at)
#  index_entries_on_relevance_calculated_at  (relevance_calculated_at)
#  index_entries_on_grain_size               (grain_size)
#

require File.dirname(__FILE__) + '/../test_helper'

class EntryTest < ActiveSupport::TestCase

  context "entry instance" do
    setup do
      @entry = Factory(:entry)
    end
    should_belong_to :feed
  end
  
end
