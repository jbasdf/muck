require 'openssl'

class Amazon
  
  # Do we have support for the SHA-256 Secure Hash Algorithm?
  # Note that Module#constants returns Strings in Ruby 1.8 and Symbols in 1.9.
  DIGEST_SUPPORT = OpenSSL::Digest.constants.include?('SHA256') || OpenSSL::Digest.constants.include?(:SHA256)

  # Requests are authenticated using the SHA-256 Secure Hash Algorithm.
  DIGEST = OpenSSL::Digest::Digest.new('sha256') if DIGEST_SUPPORT

  ECS_TO_RSS_WISHLIST = "http://www.folksemantic.com/ecs_to_rss-wishlist.xslt"
  
  AMAZON_SITES = {
    :ca => 'http://ecs.amazonaws.ca/onca/xml',
    :de => 'http://ecs.amazonaws.de/onca/xml',
    :fr => 'http://ecs.amazonaws.fr/onca/xml',
    :jp => 'http://ecs.amazonaws.jp/onca/xml',
    :uk => 'http://ecs.amazonaws.co.uk/onca/xml',
    :us => 'http://ecs.amazonaws.com/onca/xml'
  }

  AMAZON_XSLT_SITES = {
    :ca => 'http://xml-ca.amznxslt.com/onca/xml',
    :de => 'http://xml-de.amznxslt.com/onca/xml',
    :fr => 'http://xml-fr.amznxslt.com/onca/xml',
    :jp => 'http://xml-jp.amznxslt.com/onca/xml',
    :uk => 'http://xml-uk.amznxslt.com/onca/xml',
    :us => 'http://xml-us.amznxslt.com/onca/xml'
  }
  
  # Sign an amazon query
  # Requires openssl and that GlobalConfig.amazon_secret_access_key be defined.
  # Based on ruby-aaws and documentation here
  # http://www.caliban.org/ruby/ruby-aws/
  # http://docs.amazonwebservices.com/AWSECommerceService/latest/DG/index.html?RequestAuthenticationArticle.html
  # Parameters
  # query:    The query to be signed
  def self.sign_query(uri, query, amazon_secret_access_key)
    raise 'SHA-256 not available in this version of openssl.  Cannot sign Amazon requests.' unless DIGEST_SUPPORT
    query << "&Timestamp=#{Time.now.utc.strftime('%Y-%m-%dT%H:%M:%SZ')}"
    new_query = query.split('&').collect{|param| "#{param.split('=')[0]}=#{url_encode(param.split('=')[1])}"}.sort.join('&')
    to_sign = "GET\n%s\n%s\n%s" % [uri.host, uri.path, new_query]
    hmac = OpenSSL::HMAC.digest(DIGEST, amazon_secret_access_key, to_sign)
    base64_hmac = [hmac].pack('m').chomp
    signature = url_encode(base64_hmac)
    new_query << "&Signature=#{signature}"
  end
  
  # Encode a string, such that it is suitable for HTTP transmission.
  def self.url_encode(string)
    return '' if string.nil?
    # Shamelessly plagiarised from Wakou Aoyama's cgi.rb, but then altered slightly to please AWS.
    string.gsub( /([^a-zA-Z0-9_.~-]+)/ ) do
      '%' + $1.unpack( 'H2' * $1.bytesize ).join( '%' ).upcase
    end
  end
  
end