module MuckRakerHelper

  def tag_cloud(tags, classes)
    max_count = tags.first.count.to_f
    
    atags = tags.sort_by(&:name)
    atags.each do |tag|
      index = ((tag.count / max_count) * (classes.size - 1)).round
      yield tag,  classes[index]
    end
  end
  
  def round(flt)
    return (((flt.to_f*100).to_i.round).to_f)/100.0
  end
  
  def truncate_words(text, length = 30, end_string = ' ...')
    words = text.split()
    words[0..(length-1)].join(' ') + (words.length > length ? end_string : '')
  end
  def feed_query_uri(feed)
    "/search/results?terms=feed_id:" + feed.id.to_s + "&locale=en"
  end
end
