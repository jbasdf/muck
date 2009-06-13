class Muck::CommentsController < ApplicationController

  before_filter :get_parent, :only => [:create]
  before_filter :get_comment, :only => [:destroy]

  def create
    @comment = @parent.comments.build(params[:comment].merge(:user_id => current_user.id))
    respond_to do |format|
      if @comment.save
        format.js do
          render :update do |page|
            page.insert_html :top, "#{dom_id(@parent)}_comments", :partial => 'comments/comment'
            page.visual_effect :highlight, "comment_#{@comment.id}".to_sym
            page << 'tb_remove();'
            page << "jQuery('#comment_comment').val('');"
          end
        end
      else
        format.js do
          render :update do |page|
            page << "message('" + _("Oops... I could not create that comment.  %{errors}") % {:errors => @comment.errors.full_messages.to_sentence } + "');"
          end
        end
      end
    end

  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html do
        flash[:notice] = _('Comment successfully removed.')
        redirect_back_or_default current_user
      end
      format.js { render(:update){|page| page.visual_effect :puff, "#{@comment.dom_id}".to_sym}}
    end
  end  

  protected

  def get_parent
    if !params[:parent_type] || !params[:parent_id]
      raise t('uploader.missing_parent_id_error')
      return
    end
    @klass = params[:parent_type].to_s.capitalize.constantize
    @parent = @klass.find(params[:parent_id])
    unless has_permission_to_upload(current_user, @parent)
      permission_denied
    end
  end

  def get_comment
    @comment = Comment.find(params[:id])
    unless @comment.can_edit?(current_user) || is_admin?
      respond_to do |format|
        format.html do
          flash[:notice] = _("Sorry, you can't do that.")
          redirect_back_or_default current_user
        end
        format.js { render(:update){|page| page.alert _("Sorry, you can't do that.")}}
      end
    end
  end

end
