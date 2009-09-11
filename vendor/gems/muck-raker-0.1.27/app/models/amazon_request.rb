class AmazonRequest
  include HTTParty
  format :xml
  
  # Initialize Amazon Request.  Obtain valid Amazon credentials from your developer account
  # Parameters:
  # amazon_access_key_id:     Valid Amazon access key
  # amazon_secret_access_key: Valid Amazon secret access key
  # amazon_associate_tag:     Valid Amazon associates tag (optional)
  # locale:                   Locale for the specific amazon site to use valid values are :ca, :de, :fr, :jp, :uk, :us (optional, default is us)
  def initialize(amazon_access_key_id, amazon_secret_access_key, amazon_associate_tag = nil, locale = :us)
    @amazon_access_key_id = amazon_access_key_id
    @amazon_secret_access_key = amazon_secret_access_key
    @amazon_associate_tag = amazon_associate_tag
    @locale = locale
  end
  
  # Generate rss feeds for the give email
  # Parameters:
  # email:    email for which to find feeds.
  def get_amazon_feeds(email)
    wishlists = get_customer_wishlists(email)
    if !wishlists.blank?
      wishlist_ids = wishlists.collect{|list| list['ListId']}
      generate_wishlist_rss(wishlist_ids)
    end
  end
  
  # Get matching id for the given email
  # Parameters:
  # email:  customer's email.
  def get_customer_id(email)
    query = "Operation=CustomerContentSearch&Email=#{email}"
    result = make_request(query)
    if result['CustomerContentSearchResponse']['Customers']['TotalResults'].to_i > 0
      result['CustomerContentSearchResponse']['Customers']['Customer'][0]
    end
  end
  
  # Get information for the given customer id
  def get_customer_information(customer_id)
    query = "Operation=CustomerContentLookup&ResponseGroup=CustomerLists&CustomerId=#{customer_id}"
    make_request(query)
  end

  # Get customer's wishlist ids
  def get_customer_wishlists(email)
    query = "Operation=ListSearch&ListType=WishList&Email=#{email}"
    result = make_request(query)
    result['ListSearchResponse']['Lists']['List']
  end
  
  def generate_wishlist_rss(wishlist_ids)
    feeds = []
    wishlist_ids.each do |wishlist_id|
      query = "Operation=ListLookup&ListType=WishList&ListId=#{wishlist_id}&ResponseGroup=ItemAttributes,ListItems,ListInfo,Offers&Sort=DateAdded&Style=#{Amazon::ECS_TO_RSS_WISHLIST}"
      feeds << make_xslt_request(query)
    end
    feeds
  end
  
  protected
    def make_request(query)
      add_required_params(query)
      uri = Amazon::AMAZON_SITES[@locale]
      signed_query = Amazon.sign_query(URI.parse(uri), query, @amazon_secret_access_key)
      AmazonRequest.get(uri, :query => signed_query)
    end
    
    def make_xslt_request(query)
      add_required_params(query)
      uri = Amazon::AMAZON_XSLT_SITES[@locale]
      signed_query = Amazon.sign_query(URI.parse(uri), query, @amazon_secret_access_key)
      "#{uri}?#{signed_query}"
    end
    
    def add_required_params(query)
      query << "&Service=AWSECommerceService"
      query << "&AWSAccessKeyId=#{@amazon_access_key_id}"
      query << "&AssociateTag=#{@amazon_associate_tag}" if @amazon_associate_tag
      query << "&Version=2009-07-01"
    end
end
