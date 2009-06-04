if @document.nil?
	@recommendations = Array.new
else 
	@recommendations = @document.ranked_recommendations(@limit, params[:order] || "mixed")
end

headers["Content-Type"] = "application/rss+xml"
xml.instruct!
	
xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/", "xmlns:oerr" => "http://www.oerrecommender.org/oerr/elements/1.0/" do
    xml.channel do

    xml.title       "OER Recommender recommendations for " + @document.permalink
    xml.link        url_for(request.env["REQUEST_URI"])
#    xml.pubDate     CGI.rfc1123_date @entries.first.updated_at if @entries.any?
#    xml.description "Blog posts for " + @event.title
	xml.generator 'OER Recommender'

    @recommendations.each do |recommendation|
      xml.item do
        xml.link recommendation["uri"]
        xml.oerr :clicks, recommendation["clicks"]
        xml.oerr :relevance, round(recommendation["relevance"])
        xml.title recommendation["title"]
        if recommendation["description"] != nil
	        xml.description "type" => "html" do
	        	xml.text! recommendation["description"]
	        end
	    end
#        xml.pubDate     CGI.rfc1123_date recommendation.created_at
        xml.guid        "http://www.oerrecommender.org/r?id=" + recommendation["id"].to_s
#        xml.author      "#{entry.author} (#{entry.author})"
      end
    end

  end
end
