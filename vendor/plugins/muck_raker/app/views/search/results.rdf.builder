headers["Content-Type"] = "application/rdf+xml"
xml.instruct!

xml.RDF :RDF, "xmlns:RDF" => "http://www.w3.org/1999/02/22-rdf-syntax-ns#", "xmlns:result" => "http://www.oerrecommender.org/rdf#" do        
         
    xml.RDF :Description, "RDF:about"=>"http://oerrecommender.org/result" do
		xml.result :name do
		  xml.text! 'Results for ' + html_escape(request.env["REQUEST_URI"])
		end
	end
	
    @results.each do |result|
        xml.RDF :Description, "RDF:about" => result.uri do
            xml.result :title do xml.text! result.title end
		    xml.result :uri do xml.text! result.uri end
		end
	end
 
 	xml.RDF :Seq, "RDF:about" => url_for(:only_path => false, :controller => 'search') do
        @results.each do |result|
    		xml.RDF :li, "RDF:resource" => result.uri
     	end
	end
end