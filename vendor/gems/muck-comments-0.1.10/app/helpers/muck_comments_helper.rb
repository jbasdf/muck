module MuckCommentsHelper
  
  def show_comments(comments)
    render :partial => 'comments/comment', :collection => comments
  end
  
  # parent is the object to which the comments will be attached
  # comment is the optional parent comment for the new comment.
  def comment_form(parent, comment = nil, render_new = false, comment_button_class = 'comment-submit')
    render :partial => 'comments/form', :locals => {:parent => parent, 
                                                    :comment => comment, 
                                                    :render_new => render_new,
                                                    :comment_button_class => comment_button_class}
  end

  # make_muck_parent_params is defined in muck-engine and used by many of the engines.
  # This will generate a url suitable for a form to post a create to.
  def new_comment_path_with_parent(parent)
    comments_path(make_muck_parent_params(parent))
  end
  
  # Generates a link to the 'new' page for a comment
  def new_comment_for_path(parent)
    new_comment_path(make_muck_parent_params(parent))
  end
  
  # Renders a delete button for a comment
  def delete_comment(comment, button_type = :button, button_text = t("muck.activities.delete"))
    render :partial => 'shared/delete', :locals => { :delete_object => comment, 
                                                         :button_type => button_type,
                                                         :button_text => button_text, 
                                                         :form_class => 'comment-delete',
                                                         :delete_path => comment_path(comment, :format => 'js') }
  end
  
end