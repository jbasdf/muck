module MuckRakerHelper

  def tag_cloud(tag_list, classes)
    atags = tag_list.split(',')
    min = atags.shift.to_f
    max = atags.shift.to_f
    range = max - min
    scale = range == 0 ? 1 : classes.length.to_f / range.to_f
    atags.each_slice(2){|tag,index| yield tag, classes[((index.to_i - min)*scale).to_i]}
  end
  
  def tag_link(tag, css_class, grain_size)
     link_to h(tag), "/resources/tags/#{tag}?grain_size=#{grain_size}", :class => css_class
  end
  
  def filtered_tag_link(tag, filter, css_class, grain_size)
     link_to h(tag), "/resources/tags/#{filter.join('/')}/#{tag}?grain_size=#{grain_size}", :class => css_class
  end
  
  def results_status
    if @tag_filter.nil?
      if (@grain_size == 'course')
        t('muck.raker.course_search_results', 
        :first => @offset+1, 
        :last => (@offset + @per_page) < @hit_count ? (@offset + @per_page) : @hit_count,
        :total => @hit_count,
        :filter => @tag_filter,
        :terms => URI.unescape(@term_list))
      else
        t('muck.raker.resource_search_results', 
        :first => @offset+1, 
        :last => (@offset + @per_page) < @hit_count ? (@offset + @per_page) : @hit_count,
        :total => @hit_count,
        :filter => @tag_filter,
        :terms => URI.unescape(@term_list))
      end
    else
      if (@grain_size == 'course')
        t('muck.raker.course_tag_results', 
        :first => @offset+1, 
        :last => (@offset + @per_page) < @hit_count ? (@offset + @per_page) : @hit_count,
        :total => @hit_count,
        :filter => @tag_filter,
        :terms => @tag_filter.split('/').join('</b>, <b>'))
      else
        t('muck.raker.resource_tag_results', 
        :first => @offset+1, 
        :last => (@offset + @per_page) < @hit_count ? (@offset + @per_page) : @hit_count,
        :total => @hit_count,
        :filter => @tag_filter,
        :terms => @tag_filter.split('/').join('</b>, <b>'))
      end
    end
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
  
  def feed_query_uri(feed)
    "/search/results?terms=feed_id:" + feed.id.to_s + "&locale=en"
  end
  
  def already_shared_entry?(user, entry)
    user.shares.find(:all, :conditions => ['entry_id = ?', entry.id]).length > 0
  end
  
end
