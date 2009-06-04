headers["Content-Type"] = "application/xml"
xml.instruct!

xml.results(:search => URI.unescape(params[:terms]), :hits => @hit_count, :offset => @offset, :limit => @limit)do
    @results.each do |result|
        xml.result(:published_at => result.published_at, :relevance => result.solr_score) do
            xml.id result.id
            xml.title result.title
            xml.description truncate_words(result.description)
            xml.uri result.uri
            xml.direct_link result.direct_link
            xml.collection do
            	xml.title result.feed.title
            	xml.short_title result.feed.short_title
            	xml.uri result.feed.uri
           	end
        end
    end
end
