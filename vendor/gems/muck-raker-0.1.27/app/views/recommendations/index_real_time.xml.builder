xml.instruct!

if @entry.nil?
	xml.recommendations
else

@recommendations = @entry.ranked_recommendations(@limit, params[:order] || "mixed", @details)
xml.recommendations(:document_id => @entry.nil? ? "" : @entry.id, :uri => @uri, :title => t("muck.raker.gm_title"), :more_prompt => t("muck.raker.gm_more_prompt"), :direct_link_text => t("muck.raker.direct_link")) do
    @recommendations.results.each do |recommendation|
        xml.recommendation do
            xml.title recommendation["title"]
            xml.collection recommendation["collection"]
            xml.link "http://folksemantic.com/visits/" + recommendation["id"].to_s
            
            if @details == true
	            xml.description recommendation["description"]
	            xml.relevance round(recommendation["score"])
	            xml.published_at recommendation["published_at"]
	            xml.author recommendation["author"]
	        else
	            xml.description ""
	        end
        end
    end
end
end
