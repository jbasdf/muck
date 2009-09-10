class Admin::Muck::ProfilesController < Admin::Muck::BaseController
  unloadable

  def edit
    respond_to do |format|
      format.html { render :template => 'admin/profiles/edit' }
    end
  end

end
