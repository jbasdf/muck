module MuckRakerFeedsHelper
  
  def add_feed(parent = nil)
    render :partial => 'parts/add_feed', :locals => {:parent => parent}
  end
  
  def add_single_feed(parent = nil)
    render :partial => 'parts/add_single_feed', :locals => {:parent => parent}
  end
  
  def add_extended_feed(parent = nil)
    render :partial => 'parts/add_extended_feed', :locals => {:parent => parent}
  end

  def new_feed_path_with_parent(parent)
    if parent
      feeds_path(make_parent_params(parent))
    else
      feeds_path
    end
  end
    
  def make_parent_params(parent)
    { :parent_id => parent.id, :parent_type => parent.class.to_s }
  end
  
end