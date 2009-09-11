module MuckContentsHelper
  
  # share is an optional share object that can be used to pre populate the form.
  # options:
  #     html options for form:
  #     :html => {:id => 'a form'}
  def content_form(content = nil, options = {}, &block)
    content ||= Content.new
    options[:html] = {} if options[:html].nil?
    raw_block_to_partial('contents/form', options.merge(:content => content), &block)
  end
  
  # content uses friendly_id but we want the param in the form to use the number id
  def get_content_form_url(content, parent)
    if content.new_record?
      contents_path(make_muck_parent_params(parent))
    else
      content_path(content.id, make_muck_parent_params(parent))
    end
  end
  
end