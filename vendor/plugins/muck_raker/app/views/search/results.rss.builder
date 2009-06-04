headers["Content-Type"] = "application/rss+xml"
xml.instruct! :xml, :version=>"1.0"	
xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.channel do

    xml.title       'OER Recommender - Search Results for: ' + URI.unescape(params[:terms])
    xml.link        url_for(request.env["REQUEST_URI"])
    xml.pubDate     CGI.rfc1123_date Time.now
    xml.description 'OER Recommender - Search Results for: ' + URI.unescape(params[:terms])
	xml.generator 'OER Recommender'

    xml.image do
        xml.title 'Open Educational Resources logo'
        xml.url 'http://www.oerrecommender.org/images/diagram.gif'
        xml.link 'http://www.oerrecommender.org'
        xml.description 'Open Educational Resources'
    end

    @results.each do |result|
      xml.item do
        xml.title       result.title
        xml.link        result.uri
        xml.guid        result.uri
        xml.pubDate		result.published_at
        xml.description	truncate_words(result.description)
      end
    end

  end
end

