class UploadsController < Uploader::UploadsController

  before_filter :login_required
  before_filter :get_parent, :only => [:index, :create, :swfupload, :photos, :files]
  
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
  
end