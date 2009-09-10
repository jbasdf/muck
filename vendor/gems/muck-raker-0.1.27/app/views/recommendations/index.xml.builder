xml.instruct!

if @entry.nil?
	xml.recommendations
else

@recommendations = @entry.ranked_recommendations(@limit, params[:order] || "mixed", @details)
#xml.recommendations(:document_id => @entry.nil? ? "" : @entry.id, :uri => @uri, :title => t(:gm_title), :more_prompt => t(:gm_more_prompt), :direct_link_text => t(:direct_link), :locale => @entry.language) do
xml.recommendations(:document_id => @entry.nil? ? "" : @entry.id, :uri => @uri, :title => t("muck.raker.gm_title"), :more_prompt => t("muck.raker.gm_more_prompt"), :direct_link_text => t("muck.raker.direct_link")) do
    @recommendations.each do |recommendation|
        xml.recommendation do
            xml.title recommendation["title"]
            xml.collection recommendation["collection"]
            xml.link "http://folksemantic.com/r?id=" + recommendation["id"].to_s  
#            xml.link "http://localhost:3000/r?id=" + recommendation["id"].to_s
            xml.has_direct_link "true" if (recommendation["direct_link"] != nil and @uri[0..20] == recommendation["uri"][0..20]) 
            
            if @details == true
	            xml.direct_link "http://www.folksemantic.com/r?id=" + recommendation["id"].to_s + "&u=" + recommendation["direct_link"] if recommendation["direct_link"] != nil 
#	            xml.direct_link "http://localhost:3000/r?id=" + recommendation["id"].to_s + "&u=" + recommendation["direct_link"] if recommendation["direct_link"] != nil 
	            xml.uri recommendation["uri"]
	            xml.direct_uri recommendation["direct_link"]
	            xml.description recommendation["description"]
	            xml.clicks recommendation["clicks"]
	            xml.average_time_at_dest recommendation["avg_time_on_target"]
	            xml.relevance round(recommendation["relevance"])
	            xml.published_at recommendation["published_at"]
	            xml.author recommendation["author"]
	            xml.tag_list recommendation["tag_list"]
	        else
	            xml.description ""
	        end
        end
    end
end
end
