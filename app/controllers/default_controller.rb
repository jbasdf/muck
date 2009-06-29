class DefaultController < ApplicationController

  def index
    if logged_in?
      redirect_to user_path(current_user.login)
    else
      @activities = nil #current_user.activities.paginate(:page => @page, :per_page => @per_page)
      respond_to do |format|
        format.html { render }
      end
    end
  end

  def contact
    if request.post?
      send_form_email(params, t('muck.contact_request'))
      flash[:notice] = t('muck.contact_thanks') 
      redirect_to contact_url
    else
      respond_to do |format|
        format.html { render }
      end
    end
  end

  def sitemap
    respond_to do |format|
      format.html { render }
    end
  end

  def ping
    user = User.first
    render :text => 'we are up'
  end
  
end
