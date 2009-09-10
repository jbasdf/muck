headers["Content-Type"] = "application/atom+xml"
xml.instruct!

xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
    
    xml.title   "Open Educational Resources"
    xml.link    "rel" => "self", "href" => request.env["REQUEST_URI"]
    xml.id      url_for(:only_path => false, :controller => 'results')
    xml.updated CGI.rfc1123_date Time.now
    xml.author  { xml.name "Open Educational Resources" }
    
    xml.image do
        xml.title 'Open Educational Resources logo'
        xml.url 'http://www.oerrecommender.org/images/diagram.gif'
        xml.link 'http://www.oerrecommender.org'
        xml.description 'Open Educational Resources'
    end
    
    @results.each do |result|
        xml.entry do
            xml.title   result.title
            xml.link    "rel" => "alternate", "href" => result.uri
            xml.id      result.uri
        end
    end
    
end