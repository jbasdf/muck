require File.dirname(__FILE__) + '/../test_helper'

class MuckEngineLocaleHelper

  include ERB::Util
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::UrlHelper
  include MuckEngineHelper

  attr_accessor :request

end

class MuckEngineHelperTest < ActiveSupport::TestCase

  context "locale_link" do

    setup do
      @lh = MuckEngineLocaleHelper.new
      @lh.request = ActionController::TestRequest.new
    end

    should "prepend the locale to a domain without a subdomain" do
      @lh.request.host = 'folksemantic.com'
      assert_equal '<a href="http://es.folksemantic.com/">Espanol</a>', @lh.locale_link('Espanol','es')
    end

    should "use www as the subdomain when switching to english" do
       @lh.request.host = 'es.folksemantic.com'
       assert_equal '<a href="http://www.folksemantic.com/">English</a>', @lh.locale_link('English','en')
     end

     should "leave the path alone when prepending a locale subdomain" do
      @lh.request.host = 'folksemantic.com'
      @lh.request.request_uri = '/login'
      assert_equal '<a href="http://es.folksemantic.com/login">Espanol</a>', @lh.locale_link('Espanol','es')
    end

    should "replace the www subdomain with the specified locale" do
      @lh.request.host = 'www.folksemantic.com'
      assert_equal '<a href="http://es.folksemantic.com/">Espanol</a>', @lh.locale_link('Espanol','es')
    end

    should "replace locale subdomains with the specified locale" do
      @lh.request.host = 'fr.folksemantic.com'
      assert_equal '<a href="http://es.folksemantic.com/">Espanol</a>', @lh.locale_link('Espanol','es')
    end

    should "specify the locale in the query string when the domain is localhost" do
      @lh.request.host = 'localhost'
      assert_equal '<a href="http://localhost/?locale=es">Espanol</a>', @lh.locale_link('Espanol','es')
    end

    should "leave the port alone when doing a locale rewrite" do
      @lh.request.host = 'localhost'
      @lh.request.port = '3000'
      assert_equal '<a href="http://localhost:3000/?locale=es">Espanol</a>', @lh.locale_link('Espanol','es')
    end

    should "leave the port alone when doing a locale rewrite on a request that includes a path" do
      @lh.request.host = 'localhost'
      @lh.request.port = '3000'
      @lh.request.request_uri = '/users/admin'
      assert_equal '<a href="http://localhost:3000/users/admin?locale=es">Espanol</a>', @lh.locale_link('Espanol','es')
    end

    should "leave the port alone when doing a locale rewrite on a request that includes a path and already specifies a locale" do
      @lh.request.host = 'localhost'
      @lh.request.port = '3000'
      @lh.request.request_uri = '/users/admin?locale=fr'
      @lh.request.env['query_string'] = 'locale=fr'
      assert_equal '<a href="http://localhost:3000/users/admin?locale=es">Espanol</a>', @lh.locale_link('Espanol','es')
    end

    should "leave the rest of the query string alone when replacing the locale parameter" do
      @lh.request.host = 'localhost'
      @lh.request.port = '3000'
      @lh.request.request_uri = '/users/admin?test=false&locale=fr'
      assert_equal '<a href="http://localhost:3000/users/admin?test=false&amp;locale=es">Espanol</a>', @lh.locale_link('Espanol','es')
    end

    should "append the locale parameter when other query string parameters are specified" do
      @lh.request.host = 'localhost'
      @lh.request.port = '3000'
      @lh.request.request_uri = '/users/admin?test=false'
      assert_equal '<a href="http://localhost:3000/users/admin?test=false&amp;locale=es">Espanol</a>', @lh.locale_link('Espanol','es')
    end

    should "replace the locale query parameter when working from localhost if another locale is already specified" do
      @lh.request.host = 'localhost'
      @lh.request.request_uri = '/login'
      @lh.request.env['query_string'] = 'locale=fr'
      assert_equal '<a href="http://localhost/login?locale=es">Espanol</a>', @lh.locale_link('Espanol','es')
    end

    should "specify the locale in the query string when the domain is an ip address" do
      @lh.request.host = '155.23.322.13'
      assert_equal '<a href="http://155.23.322.13/?locale=es">Espanol</a>', @lh.locale_link('Espanol','es')
    end

    should "prepend the locale if multiple submdomains are specified and the first is not www" do
      @lh.request.host = 'math.folksemantic.com'
      assert_equal '<a href="http://es.math.folksemantic.com/">Espanol</a>', @lh.locale_link('Espanol','es')
    end

    should "replace the www subdomain if multiple submdomains are specified and the first is www" do
      @lh.request.host = 'www.math.folksemantic.com'
      assert_equal '<a href="http://es.math.folksemantic.com/">Espanol</a>', @lh.locale_link('Espanol','es')
    end

  end
end 

