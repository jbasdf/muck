# == Schema Information
#
# Table name: content_translations
#
#  id          :integer(4)      not null, primary key
#  content_id  :integer(4)
#  title       :string(255)
#  body        :text
#  locale      :string(255)
#  user_edited :boolean(1)
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_content_translations_on_content_id  (content_id)
#  index_content_translations_on_locale      (locale)
#

class ContentTranslation < ActiveRecord::Base
  acts_as_muck_content_translation
end
