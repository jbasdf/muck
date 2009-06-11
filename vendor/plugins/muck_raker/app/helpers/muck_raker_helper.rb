module MuckRakerHelper

  def tag_cloud(tag_list, classes)
    tag_list.split(',').each_slice(2){|tag,index| yield tag, classes[index.to_i]}
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
end
