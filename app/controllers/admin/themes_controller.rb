class Admin::ThemesController < Admin::Disguise::ThemesController
  before_filter :login_required
  before_filter :admin_access_required
  
  def update
    CmsLite.remove_content_path("themes/#{@theme.name}/content", false)
    CmsLite.append_content_path("themes/#{params[:theme][:name]}/content")
    super
  end
  
end