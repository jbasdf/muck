module MuckEngineHelper

  def custom_form_for(record_or_name_or_array, *args, &proc) 
    options = args.detect { |argument| argument.is_a?(Hash) } 
    if options.nil? 
      options = {:builder => MuckCustomFormBuilder} 
      args << options 
    end 
    options[:builder] = MuckCustomFormBuilder unless options.nil? 
    form_for(record_or_name_or_array, *args, &proc) 
  end
  
  def custom_remote_form_for(record_or_name_or_array, *args, &proc) 
    options = args.detect { |argument| argument.is_a?(Hash) } 
    if options.nil? 
      options = {:builder => MuckCustomFormBuilder} 
      args << options 
    end 
    options[:builder] = MuckCustomFormBuilder unless options.nil? 
    remote_form_for(record_or_name_or_array, *args, &proc) 
  end
  
  def output_flash(options = {})
    output_errors('', options)
  end
  
  def output_errors(title, options = {}, fields = nil)
    fields = [fields] unless fields.is_a?(Array)
    flash_html = render(:partial => 'shared/flash_messages')
    flash.clear
    field_errors = render(:partial => 'shared/field_error', :collection => fields)
    css_class = "class=\"#{options[:class]}\"" unless options[:class].nil?
    
    if !flash_html.empty? && field_errors.empty?
      # only flash.  Don't render the 
      render(:partial => 'shared/flash_error_box', :locals => {:flash_html => flash_html, :css_class => css_class})
    elsif !field_errors.empty?
      # field errors and/or flash
      render(:partial => 'shared/error_box', :locals => {:title => title, 
        :flash_html => flash_html, 
        :field_errors => field_errors,
        :css_class => css_class,
        :extra_html => options[:extra_html]})
    else
      #nothing
      ''
    end
  end
  
  # Render a photo for the given object.  Note that the object will need a 'photo' method
  # provided by paperclip.
  # size is commonly one of:
  # :medium, :thumb, :icon or :tiny but can be any value provided by the photo object
  def icon(object, size = :icon)
    return "" if object.blank?
    image_url = object.photo.url(size) rescue '/images/profile_default.jpg'
    link_to(image_tag(image_url, :class => size), object, { :title => object.full_name })
  end
  
  def secure_mail_to(email)
    mail_to email, nil, :encode => 'javascript'
  end
  
  # Used inside of format.js to return a message to the client.
  # If jGrowl is enabled the message will show up as a growl instead of a popup
  def page_alert(page, message, title = '')
    if GlobalConfig.growl_enabled
      page << "jQuery.jGrowl.error('" + message + "', {header:'" + title + "'});"
    else
      page.alert(message)
    end
  end
  
  # Override link_to_remote so that instead of '#' the proper url is rendered
  # This makes the link usable even if javascript is disabled
  # See: http://www.intridea.com/2007/11/21/link_to_remote-unobtrusively
  def link_to_remote(name, options = {}, html_options = {})  
    html_options.merge!({:href => url_for(options[:url])}) unless options[:url].blank?
    super(name, options, html_options)  
  end
  
  def locale_link(name, locale)
    link_to name, request.protocol + locale + '.' + request.domain + request.request_uri
    #link_to name, request.url.gsub(request.protocol, "#{request.protocol}#{locale}.")
    #link_to name, request.url.sub(request.protocol, "#{request.protocol}#{locale}.").sub('www.','')
    protocol = request.protocol
    if request.domain.count('.') == 1
      new_domain = request.url.sub(protocol, "#{protocol}#{locale}.")
    else
      new_domain = request.url.sub(Regexp.new(protocol + "[^\.]+."), "#{protocol}#{locale}.")
    end
    link_to name, new_domain
  end

  # Generate parameters for a url that refer to a given object as parent.  Useful
  # for comments, shares, etc
  def make_muck_parent_params(parent)
    return if parent.blank?
    { :parent_id => parent.id, :parent_type => parent.class.to_s }
  end
  
  # Take a block and renders that block within the context of a partial.
  # from http://snippets.dzone.com/posts/show/2483
  def block_to_partial(partial_name, options = {}, &block)
    options.merge!(:body => capture(&block))
    concat(render(:partial => partial_name, :locals => options))
  end
    
  # Take a block and renders that block within the context of a partial.
  # Passes the block to the partial.  The partial is then responsible for
  # capturing and rendering the block.
  # from http://snippets.dzone.com/posts/show/2483
  def raw_block_to_partial(partial_name, options = {}, &block)
    options.merge!(:block => block)
    concat(render(:partial => partial_name, :locals => options))
  end
  
  # Summarize html content by removing html
  # tags and truncating at a given number of words.
  # Truncation will occur at word boundries
  # Parameters:
  #   text    - The text to truncate
  #   length  - The desired number of words
  #   omission  - Text to add when the text is truncated ie 'read more'
  def html_summarize(text, length = 30, omission = '...')
    snippet(strip_tags(text), length, omission)
  end
  
  # Truncates text at a word boundry and provides a 
  # parameter for a 'more link'
  # Parameters:
  #   text      - The text to truncate
  #   wordcount - The number of words
  #   omission  - Text to add when the text is truncated ie 'read more'
  def snippet(text, wordcount, omission)
   text.split[0..(wordcount-1)].join(" ") + (text.split.size > wordcount ? " " + omission : "")
  end
  
  def round(flt)
    return (((flt.to_f*100).to_i.round).to_f)/100.0
  end

  def truncate_on_word(text, length = 270, end_string = ' ...')
    if text.length > length
      stop_index = text.rindex(' ', length)
      stop_index = length - 10 if stop_index < length-10
      text[0,stop_index] + (text.length > 260 ? end_string : '')
    else
      text
    end
  end
  
  def truncate_words(text, length = 40, end_string = ' ...')
    words = text.split()
    words[0..(length-1)].join(' ') + (words.length > length ? end_string : '')
  end
  
  # Outputs a javascript include localized for specific time actions
  def time_scripts(locale)
    render :partial => 'scripts/time_scripts', :locals => {:locale => locale}
  end

end
