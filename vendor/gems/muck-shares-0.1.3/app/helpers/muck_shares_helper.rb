module MuckSharesHelper

  def show_shares(shares)
    render :partial => 'shares/share', :collection => shares
  end

  # share is an optional share object that can be used to pre populate the form.
  # options:
  # render_new - will determine whether the controller will redirect to new after create or 
  #              attempt to return to the last page stored by store_location
  def share_form(share = nil, options = {}, &block)
    share ||= Share.new
    raw_block_to_partial('shares/form', options.merge(:share => share), &block)
  end  

  # Renders a delete button for a share item
  def delete_share(share, button_type = :button, button_text = t("muck.general.delete"))
    render :partial => 'shared/delete', :locals => { :delete_object => share,
                                                     :button_type => button_type,
                                                     :button_text => button_text,
                                                     :form_class => 'comment-delete',
                                                     :delete_path => share_path(share, :format => 'js') }
  end

  def already_shared?(user, uri)
    user.shares.find(:all, :conditions => ['uri = ?', uri])
  end
  
end