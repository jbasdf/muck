# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class Solr::Request::Mlt < Solr::Request::Select

  VALID_PARAMS = [:query, :sort, :default_field, :operator, :start, :rows, :shards, :date_facets,
    :filter_queries, :field_list, :debug_query, :explain_other, :facets, :highlighting, :mlt, 'stream.url']
  
  def initialize(params)
    super('mlt', params)
    
    raise "Invalid parameters: #{(params.keys - VALID_PARAMS).join(',')}" unless 
      (params.keys - VALID_PARAMS).empty?
    
    raise "'stream.url' parameter required" unless params['stream.url']
    
    @params = params.dup
    
    @params[:field_list] ||= ["pk_i","score"]
  end
  
  def to_hash
    hash = {}
    
    # standard request param processing
    sort = @params[:sort].collect do |sort|
      key = sort.keys[0]
      "#{key.to_s} #{sort[key] == :descending ? 'desc' : 'asc'}"
    end.join(',') if @params[:sort]
    #hash[:q] = sort ? "#{@params[:query]};#{sort}" : @params[:query]
    hash["q.op"] = @params[:operator]
    hash[:df] = @params[:default_field]

    # common parameter processing
    hash[:start] = @params[:start] || '0'
    hash[:rows] = @params[:rows] || '10'
    hash[:fq] = @params[:filter_queries]
    hash[:fl] = @params[:field_list].join(',') 
    hash[:debugQuery] = @params[:debug_query]
    hash[:explainOther] = @params[:explain_other]
    
    hash[:qt] = 'mlt'
    hash[:wt] = 'ruby'
    hash['stream.url'] = @params[:query]
    
#    hash[:mlt] = true
    if @params[:mlt]
      hash["mlt.count"] = @params[:mlt][:count]
      hash["mlt.fl"] = @params[:mlt][:field_list].join(',')
      hash["mlt.mintf"] = @params[:mlt][:min_term_freq]
      hash["mlt.mindf"] = @params[:mlt][:min_doc_freq]
      hash["mlt.minwl"] = @params[:mlt][:min_word_length]
      hash["mlt.maxwl"] = @params[:mlt][:max_word_length]
      hash["mlt.maxqt"] = @params[:mlt][:max_query_terms]
      hash["mlt.maxntp"] = @params[:mlt][:max_tokens_parsed]
      hash["mlt.boost"] = @params[:mlt][:boost]
    end
    
    hash.merge(super.to_hash)
  end

end
