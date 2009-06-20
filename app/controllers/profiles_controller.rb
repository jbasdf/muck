class ProfilesController < Muck::ProfilesController
  
  #before_filter :search_results, :only => [:index, :search]
  before_filter :store_location, :only => [:index, :show, :edit]
  
  def index
    respond_to do |format|
      format.html { render :template => 'profiles/index' }
    end
  end

  # def search
  #   respond_to do |format|
  #     format.html { render :template => 'profiles/index' }
  #   end
  # end

  # show a given user's public profile information
  def show
    @user = User.find(params[:user_id])
    @profile = @user.profile
    @title = @user.display_name
    respond_to do |format|
      format.html { render :template => 'profiles/show' }
    end
  end

  def edit
    @title = t('muck.profiles.edit_profile')
    @user = User.find(params[:user_id])
    @profile = @user.profile
    respond_to do |format|
      format.html { render :template => 'profiles/edit' }
    end
  end
  
  def update
    @title = t('muck.profiles.edit_profile')
    @user = User.find(params[:user_id])
    @profile = @user.profile
    @profile.update_attributes!(params[:profile])
    respond_to do |format|
      flash[:notice] = t('muck.profiles.edit_success')
      format.html { redirect_back_or_default edit_user_profile_path(@user) }
    end
  rescue ActiveRecord::RecordInvalid => ex
    flash[:error] = t('muck.profiles.edit_failure')
    render :action => :edit
  end
  
  
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