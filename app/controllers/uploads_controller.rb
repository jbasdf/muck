class UploadsController < Uploader::UploadsController

  before_filter :login_required
  before_filter :setup_parent, :only => [:index, :create, :swfupload, :photos, :files]

  def index
    @upload = Upload.new
    @uploads = @parent.uploads.paginate(:page => @page, :per_page => @per_page, :order => 'created_at desc')
    respond_to do |format|
      format.html { render }
      format.rss { render :layout => false }
    end
  end
  
  def photos
    @images = @parent.uploads.images.paginate(:page => @page, :per_page => @per_page, :order => 'created_at desc')
    respond_to do |format|
      format.html { render }
      format.rss { render :layout => false }
    end
  end
  
  def files
    @files = @parent.uploads.files.paginate(:page => @page, :per_page => @per_page, :order => 'created_at desc')
    respond_to do |format|
      format.js { render :json => basic_uploads_json(@files) }
    end
  end

  protected
  
    def get_upload_text(upload)
      render_to_string( :partial => 'uploads/upload_row', :object => upload, :locals => { :style => 'style="display:none;"', :parent => @parent } )
    end
    
    def get_redirect
      @parent
    end

    def has_permission_to_upload(user, upload_parent)
      upload_parent.can_edit?(user)
    end
  
    def permission_denied
      message = t("uploader.permission_denied")
      respond_to do |format|
        format.html do
          flash[:notice] = message
          redirect_to get_redirect
        end
        format.js { render :text => message }
        format.json { render :json => { :success => false, :message => message } }
      end
    end
  
end