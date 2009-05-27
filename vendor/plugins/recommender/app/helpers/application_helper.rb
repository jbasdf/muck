# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  include TagsHelper
  
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
