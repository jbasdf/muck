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

  @@locale_ids = nil

  def self.locale_id
    cache_locale_ids
    @@locale_ids[I18n.locale]
  end

  def self.supported_locale? locale
    cache_locale_ids
    @@locale_ids[locale.to_sym] != nil
  end

  private

  def self.cache_locale_ids
    if !@@locale_ids
      languages = Language.find(:all, :select => 'id, locale', :conditions => ['languages.supported = ?', true])
      @@locale_ids = Hash[*languages.collect {|v|[v.locale.to_sym, v.id]}.flatten]
    end
  end
  
end
