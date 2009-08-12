class Content < ActiveRecord::Base
  acts_as_muck_content(
    :git_repository => GlobalConfig.content_git_repository,
    :enable_auto_translations => GlobalConfig.enable_auto_translations,
    :enable_solr => GlobalConfig.content_enable_solr
  )
  
  acts_as_muck_post

end
