class Muck::CommentsController < ApplicationController
  unloadable
  
  before_filter :setup_parent, :only => [:new, :create]
  before_filter :has_permission?, :only => [:new, :create]
  before_filter :get_comment, :only => [:destroy]
  
  def index
    @parent = get_parent
    @comment = Comment.find(params[:id]) rescue nil
    @comments = @parent.comments.by_newest if !@parent.blank?
    @comments ||= @comment.children if !@comment.blank?
    #@comments ||= Comment.by_newest
    
    respond_to do |format|
      format.html { render :template => 'comments/index', :layout => 'popup' }
      format.pjs { render :template => 'comments/index', :layout => false }
    end
  end
  
  def new
    title = @parent.title rescue ''
    title ||= @parent.name rescue ''
    if title.blank?
      @page_title = t('muck.comments.new_comment_no_title')
    else
      @page_title = t('muck.comments.new_comment_with_title', :title => title)
    end
    respond_to do |format|
      format.html { render :template => 'comments/new', :layout => 'popup' }
      format.pjs { render :template => 'comments/new', :layout => false }
    end
  end
  
  def create
    @comment = @parent.comments.build(params[:comment])
    @comment.user = current_user
    @comment.save!
    message = t('muck.comments.create_success')
    handle_after_create(true, message)
  rescue ActiveRecord::RecordInvalid => ex
    if @comment
      errors = @comment.errors.full_messages.to_sentence
    else
      errors = ex
    end
    message = t('muck.comments.create_error', :errors => errors)
    handle_after_create(false, message)
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html do
        flash[:notice] = t('muck.comments.comment_removed')
        redirect_back_or_default(current_user)
      end
      format.js do
        render(:update) do |page|
          page << "jQuery('##{@comment.dom_id}').fadeOut();"
        end
      end
      format.json { render :json => { :success => true, :message => t("muck.comments.comment_removed"), :comment_id => @comment.id } }
    end
  end  

  protected

  def handle_after_create(success, message = '')
    if success
      respond_to do |format|
        format.html { do_after_create_action(success, message) }
        format.json { render :json => { :success => true, :comment => @comment, :message => message, :parent_id => @parent.id, :html => get_parent_comment_html(@parent, @comment) } }
      end
    else
      respond_to do |format|
        format.html { do_after_create_action }
        format.json { render :json => { :success => false, :message => message, :errors => @errors } }
      end
    end
  end
  
  def do_after_create_action(success, message)
    flash[:error] = message if !success
    if "true" == params[:render_new]
      flash[:notice] = message if success
      render :template => 'comments/new'
    else
      redirect_back_or_default(@parent)
    end
  end
  
  def get_comment
    @comment = Comment.find(params[:id])
    unless @comment.can_edit?(current_user)
      respond_to do |format|
        format.html do
          flash[:notice] = I18n.t('muck.comments.cant_delete_comment')
          redirect_back_or_default current_user
        end
        format.js { render(:update){|page| page.alert I18n.t('muck.comments.cant_delete_comment')}}
      end
    end
  end

  def get_parent_comment_html(parent, comment)
    render_as_html do
      render_to_string(:partial => "#{parent.class.to_s.tableize}/comment", :object => comment, :locals => {:comment_owner => parent})
    end
  rescue ActionView::MissingTemplate
    render_as_html do
      render_to_string(:partial => "comments/comment", :object => comment, :locals => {:comment_owner => parent})
    end
    #I18n.t('muck.comments.missing_comment_template_error', :partial => "#{parent.class.to_s.tableize}/comment")
  end
  
  def has_permission?
    @parent.can_comment?(current_user)
  end
  
end
