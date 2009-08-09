class Content < ActiveRecord::Base
  acts_as_muck_content(
    :git_repository => GlobalConfig.content_git_repository,
    :enable_auto_translations => GlobalConfig.enable_auto_translations,
    :enable_solr => GlobalConfig.content_enable_solr
  )
  
  acts_as_muck_post
  
  # Add search to your content.  Be sure to install muck-solr or another acts_as_solr.  This is left
  # for the model so that you can choose what kind of search to implement
  acts_as_solr :fields => [ :search_content ]
  def search_content
    "#{title} #{body} #{tags.collect{|t| t.name}.join(' ')}"
  end

end
