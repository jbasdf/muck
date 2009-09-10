class Muck::ContentsController < ApplicationController
  unloadable
  
  before_filter :login_required, :only => [:create, :edit, :update, :destroy]
  before_filter :setup_parent, :only => [:new, :create]
  before_filter :get_secure_content, :only => [:edit, :update, :destroy]
  before_filter :setup_layouts, :only => [:new, :create, :edit, :update]
  
  def show
    handle_content_request
  end

  # If a content object is not found this method will render a 404 for users that are not allowed to add content.
  # If the user is allowed to add content a redirect to new is performed so that the content can be added.
  #
  # Notes:
  # Override 'new' by setting up @content and passing in a custom message via @new_content_message
  # For example:
  #    def new
  #      @content = Content.new(:custom_scope => 'my-stuff')
  #      @new_content_message = 'Add Content to My Stuff'
  #      super
  #    end
  #
  # It is also simple to override the new template.  Simply create a template in app/views/contents/new.html.erb 
  # and add something similar to the following:
  #    <div id="add_content">
  #      <%= output_errors(t('muck.contents.problem_adding_content'), {:class => 'help-box'}, @content) %>
  #      <% content_form(@content) do |f| -%>
  #        <%# Add custom fields here.  ie %>
  #        <%= f.text_field :custom_thing %>
  #      <% end -%>
  #    </div>
  def new
    @content ||= Content.new
    @content.uri = params[:path] if params[:path]
    if logged_in? && has_permission_to_add_content(current_user, @parent, @content)
      flash[:notice] = @new_content_message || t('muck.contents.page_doesnt_exist_create')
      respond_to do |format|
        format.html { render :template => 'contents/new'}
        format.pjs { render :template => 'contents/new', :layout => 'popup'}
      end
    else
      # TODO think about caching this:
      @content = Content.find('404-page-not-found', :scope => MuckContents::GLOBAL_SCOPE) rescue nil
      if @content.blank?
        @content = Content.new(:title => I18n.t('muck.contents.default_404_title'), :body_raw => I18n.t('muck.contents.default_404_body'), :locale => I18n.locale.to_s)
        @content.uri = '/404-page-not-found'
        @content.save!
      end
      @title = @content.locale_title(I18n.locale)
      respond_to do |format| 
        format.html { render :template => "contents/show", :status => 404 }
        format.all  { render :nothing => true, :status => 404 } 
      end
    end
  end
  
  def create
    @content = Content.new(params[:content])
    @content.contentable = @parent if @parent
    @content.creator = current_user
    @content.current_editor = current_user
    @content.locale ||= I18n.locale
    return permission_denied unless has_permission_to_add_content(current_user, @parent, @content)
    
    @content.save!
    respond_to do |format|
      format.html do
        redirect_back_or_default(@content.uri)
      end
      format.json { render :json => { :success => true, :content => @content, :parent_id => @parent ? @parent.id : nil } }
    end
  rescue ActiveRecord::RecordInvalid => ex
    if @content
      @errors = @content.errors.full_messages.to_sentence
    else
      @errors = ex
    end
    message = t('muck.contents.create_error', :errors => @errors)
    respond_to do |format|
      format.html do
        flash[:error] = message
        render :template => 'contents/new'
      end
      format.json { render :json => { :success => false, :message => message, :errors => @errors } }
    end
  end

  def edit
    @page_title = @content.locale_title(I18n.locale)
    respond_to do |format|
      format.html { render :template => 'contents/edit'}
      format.pjs { render :template => 'contents/edit', :layout => 'popup'}
    end
  end
  
  def update
    @content.current_editor = current_user
    @content.update_attributes(params[:content])
    respond_to do |format|
      format.html do
        redirect_back_or_default(@content.uri)
      end
      format.json { render :json => { :success => true, :content => @content, :parent_id => @parent ? @parent.id : nil } }
    end
  end
  
  def destroy
    @content.destroy
    respond_to do |format|
      format.html do
        flash[:notice] = t('muck.contents.content_removed')
        redirect_back_or_default(current_user)
      end
      format.js do
        render(:update) do |page|
          page << "jQuery('##{@content.dom_id}').fadeOut();"
        end
      end
      format.json { render :json => { :success => true, :message => t("muck.contents.content_removed"), :content_id => @content.id } }
    end
  end  

  protected
    
    # Setups up the layouts that are available in the 'layouts' pulldown.
    # Override this method to change the available layouts. Note that the
    # layout will need to exist in your 'views/layouts' directory
    def setup_layouts
      @content_layouts = []
      get_layouts(File.join(RAILS_ROOT, 'app', 'views', 'layouts')).each do |layout|
        @content_layouts << OpenStruct.new(:name => layout.titleize, :value => layout)
      end
    end
    
    def get_layouts(path)
      layouts = []
      Dir.glob("#{path}/*").each do |layout_file|
        if File.directory?(layout_file)
          layouts << get_layouts(layout_file)
        else
          if layout_file.include?('.html.erb') || layout_file.include?('.html.haml')
            trimmed_layout_file = File.basename(File.basename(layout_file, '.*'), '.*') # get ride of html.erb, html.haml
            if trimmed_layout_file.first != '_'&& # don't include partials
              layouts << trimmed_layout_file
            end
          end
        end
      end
      layouts.flatten
    end

    # This method checks to see if the specified user has the right o
    # add content.  Override this method in an individual controller
    # to provide more restrictive or more liberal permissions.
    # Parameters:
    # user    - The user attempting to add content.
    # parent  - The parent object of the content.  May be nil.
    # content - The content to be added.  In an overridden method may want to check scope on the content
    #           to be sure a user doesn't attempt to change the scope to something they shouldn't have
    #           permission to.
    def has_permission_to_add_content(user, parent, content)
      return true if user.can_add_root_content?
      return false if parent.blank?
      parent.can_add_content?(user)
    end
    
    # Pass the numeric id to this method to ensure that the operations update and delete occur on the correct object
    def get_secure_content
      @content = Content.find(params[:id])
      unless @content.can_edit?(current_user)
        respond_to do |format|
          format.html do
            flash[:notice] = I18n.t('muck.contents.cant_delete_content')
            redirect_back_or_default current_user
          end
          format.js { render(:update){|page| page.alert I18n.t('muck.contents.cant_delete_content')}}
        end
      end
    end
    
    def setup_parent
      @parent = get_parent
    end
end
