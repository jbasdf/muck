module MuckActivityHelper

  def activity_comments(activity)
    render :partial => 'activities/comments', :locals => { :activity => activity }
  end
  
  def activity_comment_link(activity, comment = nil)
    if GlobalConfig.enable_activity_comments
      comment_form(activity, comment)
    end
  end
  
  def activity_scripts
    render( :partial => "activities/activity_scripts")
    time_scripts(I18n.locale)
  end
  
  # Renders an activity feed using the cache where possible
  # activities: the activities for the feed
  # limited: a value passed to each activity template which can result in a smaller amount of data 
  #          being rendered
  def cached_activities(activities, limited = false)
    return '' if activities.blank?
    render( :partial => "activities/cached_activities", :locals => {:activities => activities, :limited => limited})
  end

  def has_comments_css(activity)
    if activity.has_comments?
      'activity-has-comments'
    else
      'activity-no-comments'
    end
  end
  
  # Renders an activity with only activities created by activities_object
  # activities_object: object to get activities for
  # limited: a value passed to each activity template which can result in a smaller amount of data 
  #          being rendered
  def limited_activity_feed_for(activities_object, limited = false)
    activities = activities_object.activities.latest.created_by(activities_object).only_public.find(:all, :include => ['comments']).paginate(:page => @page, :per_page => @per_page)
    render :partial => 'activities/activity_feed', :locals => { :activities_object => activities_object, :activities => activities, :limited => limited }
  end
  
  # Renders a full activity feed for activities_object
  # activities_object: object to get activities for
  # limited: a value passed to each activity template which can result in a smaller amount of data 
  #          being rendered
  def activity_feed_for(activities_object, limited = false)
    activities = get_activities(activities_object)
    render :partial => 'activities/activity_feed', :locals => { :activities_object => activities_object, :activities => activities, :limited => limited }
  end

  # Renders a status update form for activities_object
  def status_update(activities_object)
    render :partial => 'activities/status_update', :locals => { :activities_object => activities_object }
  end

  # Renders a status update form for activities_object that has photo and file upload as well as video sharing.
  def contribute(activities_object)
    render :partial => 'activities/contribute', :locals => { :activities_object => activities_object }
  end
  
  # Renders the last status update made by activities_object
  def current_status(activities_object)
    render :partial => 'activities/current_status_wrapper', :locals => { :activities_object => activities_object }
  end
  
  # Renders a delete button for an activity
  def delete_activity(activity, button_type = :button, button_text = t("muck.activities.clear"))
    render :partial => 'shared/delete', :locals => { :delete_object => activity, 
                                                     :button_type => button_type,
                                                     :button_text => button_text,
                                                     :form_class => 'activity-delete',
                                                     :delete_path => activity_path(activity, :format => 'js') }
  end

  # Renders a delete button for a comment inside an activity feed
  def delete_activity_comment(comment, button_type = :button, button_text = t("muck.activities.delete"))
    render :partial => 'shared/delete', :locals => { :delete_object => comment, 
                                                         :button_type => button_type,
                                                         :button_text => button_text, 
                                                         :form_class => 'comment-delete',
                                                         :delete_path => comment_path(comment, :format => 'js') }
  end
  
  # Renders an activity feed filter.  Filter items come from the name of the templates used to render the activities.
  # Pass in an array of templates to leave out as the second parameter
  def activity_filter(activities_object, *dont_include)
    dont_include = [dont_include] unless dont_include.is_a?(Array)
    activity_types = activities_object.activities.all(:select => "DISTINCT activities.template")
    filter_types = activity_types.find_all {|activity| !dont_include.include?(activity.template)}
    render :partial => 'activities/template_filter', :locals => { :activity_types => filter_types, :dont_include => dont_include }
  end

  def is_current_filter?(template)
    if params[:activity_filter] == template
      'current'
    end
  end
  
  def no_filter?
    if params[:activity_filter].blank?
      'current'
    end
  end
  
  def all_activities_url
    request.url.gsub(request.query_string, '')
  end
  
  def get_profile_activities(activities_object)
    if !params[:latest_activity_id].blank?
      activities_object.activities.latest.filter_by_template(params[:activity_filter]).after(params[:latest_activity_id]).only_public.created_by(activities_object).find(:all, :include => ['comments']).paginate(:page => @page, :per_page => @per_page)
    else
      activities_object.activities.latest.filter_by_template(params[:activity_filter]).only_public.created_by(activities_object).find(:all, :include => ['comments']).paginate(:page => @page, :per_page => @per_page)
    end
  end
  
  def get_activities(activities_object)
    if !params[:latest_activity_id].blank?
      activities_object.activities.latest.filter_by_template(params[:activity_filter]).after(params[:latest_activity_id]).find(:all, :include => ['comments']).paginate(:page => @page, :per_page => @per_page)
    else
      activities_object.activities.latest.filter_by_template(params[:activity_filter]).find(:all, :include => ['comments']).paginate(:page => @page, :per_page => @per_page)
    end
  end

  # Render an activity using a block and the given activity.
  # options:
  # activity_css_class - css class to attach to the given activity
  def activity_for(activity, options = {}, &block)
    block_to_partial('activity_templates/generic', options.merge(:activity => activity), &block)
  end
    
end