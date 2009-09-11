class Muck::SearchController < ApplicationController

  unloadable
  
  def initialize
    @limit = 50
    @no_index = true
  end

  #########################################################
  # Show search page if there is nothing specified to search for
  # or if there are searchable params search for them
  def index
    if request.post?
      if params[:form_terms].nil? or params[:form_terms].empty?
        flash[:message] = 'Please enter something to search for.'
      else
        redirect_to '/search/results?terms=' + URI.escape(params[:form_terms])
      end
    end
  end

  #########################################################
  # search all fields for the given terms
  def results
    @page_title = "Search"
    @language = params[:locale] || 'en'
    @languages = Language.find(:all, :order => "name")
    @limit = params[:limit] ? params[:limit].to_i : 10
    @limit = 25 if @limit > 25
    @offset = params[:offset] ? params[:offset].to_i : 0
    @term_list = ''
    if !params[:terms].nil? && !params[:terms].empty?
      @term_list += URI.escape(params[:terms])
    end

    if request.post?
      if params[:form_terms].nil? or params[:form_terms].empty?
        flash[:message] = 'Please enter something to search for.'
        redirect_to '/'
      else
        redirect_to '/search/results?terms=' + URI.escape(params[:form_terms]) + (@language.nil? ? "" : "&locale=" + @language)
      end
    else
      @current_uri = '/search/results'
      if params[:terms]
        @url_terms = '?terms=' + @term_list
        results = Entry.search(URI.unescape(params[:terms]), @language, @limit, @offset)
        @results = results.records
        @hit_count = results.total
        @terms = URI.unescape(params[:terms])
      else
        @url_terms = ''
        @results = []
        @terms = '' 
      end

      respond_to do |format|
        format.html 
        format.xml  { render :layout=>false }
        format.rss  { render :layout=>false }
        format.pjs { 
          @json_results = ActiveSupport::JSON.encode(@results)
          render(:template => 'search/results.pjs.erb', :layout => false)  
        }
        format.atom { render :layout=>false }
        format.rdf  { render :layout=>false }
      end
    end
  end

  #########################################################
  # all the results are rendered the same
  def render_search
    respond_to do |format|
      format.html { render :template => '/search/index' }
      format.xml  { render :xml => flash.to_xml }
      format.rss  { render :xml => flash.to_xml }
      format.atom  { render :xml => flash.to_xml }
      format.rdf  { render :xml => flash.to_xml }
    end
  end

end
