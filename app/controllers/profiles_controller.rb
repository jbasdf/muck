class ProfilesController < Muck::ProfilesController
  
  #before_filter :search_results, :only => [:index, :search]
  before_filter :store_location, :only => [:index, :show, :edit]
  
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