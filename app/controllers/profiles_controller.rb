class ProfilesController < Muck::ProfilesController
  
  #before_filter :search_results, :only => [:index, :search]
  before_filter :store_location, :only => [:index, :show, :edit]
  
  def index
    @users = User.by_newest.paginate(:page => @page, :per_page => @per_page, :include => 'profile')
  end
  
  def show
    @user = User.find(params[:id])
    @profile = @user.profile
    @page_title = @user.display_name
    
    @number_of_items = 5
    @number_of_images = 10
    @number_of_videos = 5
    @load_feeds_on_server = true
    @show_combined = false
    
    @user_feeds = @user.own_feeds
    if @load_feeds_on_server
      @server_loaded_user_feeds = GoogleFeedRequest.load_feeds(@user_feeds, @number_of_items)
      if @show_combined
        @server_combined_user_feeds = Feed.combine_sort(@server_loaded_user_feeds)
      end
    end
    respond_to do |format|
      format.html { render :template => 'profiles/show' }
    end
  end
  
  # def search
  #   respond_to do |format|
  #     format.html { render :template => 'profiles/index' }
  #   end
  # end
  
  private

  # def search_results
  #   @query = params[:q]
  #   @per_page = 20
  #   @browse = @query ? 'search' : params[:browse] || 'date' 
  # 
  #   #      field_list = logged_in? ? 'protected_profile AS profile' : 'public_profile AS profile'
  #   #      field_list = 'public_profile AS profile'
  #   field_list = '*'
  # 
  #   @query = nil if (@query == '*') 
  # 
  #   if !@query.nil?
  #     @results = User.find_by_solr("#{search_field}:(#{@query})", :offset => (@page-1)*@per_page, :limit => @per_page).results
  # 
  #   elsif @browse == 'alpha'
  #     @alpha_index = params[:alpha_index] || 'A'
  #     @results = User.find(:all, :select => field_list, :conditions => ["last_name LIKE ?", @alpha_index + '%'], :order => 'last_name, first_name').paginate(:page => @page, :per_page => @per_page)
  #   else
  #     @results = User.find(:all, :select => field_list, :order => 'created_at DESC').paginate(:page => @page, :per_page => @per_page)
  #   end
  #   flash[:notice] = @results.empty? ? _('No profiles were found that matched your search.') : nil
  # end
  
end