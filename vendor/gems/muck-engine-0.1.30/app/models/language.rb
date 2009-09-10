# == Schema Information
#
# Table name: languages
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  english_name :string(255)
#  locale       :string(255)
#  supported    :boolean         default(TRUE)
#  is_default   :integer         default(0)
#

class Language < ActiveRecord::Base

  def self.locale_id
    languages = Language.find(:all, :select => 'id, locale', :conditions => 'languages.muck_raker_supported = true')
    @@locale_ids ||= Hash[*languages.collect {|v|[v.locale.to_sym, v.id]}.flatten]
    @@locale_ids[I18n.locale]
  end
  
end
