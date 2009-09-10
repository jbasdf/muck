require File.dirname(__FILE__) + '/../test_helper'

class Muck::SharesControllerTest < ActionController::TestCase

  tests Muck::SharesController

  context "shares controller" do
    
    context "not logged in" do
      setup do
        @user = Factory(:user)
      end
      context "GET index user specified" do
        setup do
          @user.shares.build(Factory.attributes_for(:share))
          @user.shares.build(Factory.attributes_for(:share))
          get :index, :user_id => @user.to_param, :format => 'html'
        end
        should_not_set_the_flash
        should_respond_with :success
        should_render_template :index
      end
    end
    
    context "logged in" do
      setup do
        activate_authlogic
        @user = Factory(:user)
        login_as @user
      end

      context "GET new" do
        setup do
          get :new
        end
        should_not_set_the_flash
        should_respond_with :success
        should_render_template :new
      end

      context "GET new with" do
        setup do
          @title = 'Example'
          @uri = 'http://www.example.com'
          @message = 'a message'
        end
        context "full params" do
          setup do
            get :new, :uri => @uri, :title => @title, :message => @message
          end
          should_not_set_the_flash
          should_respond_with :success
          should_render_template :new
          should "setup the share" do
            assert_equal @uri, assigns(:share).uri
            assert_equal @title, assigns(:share).title
            assert_equal @message, assigns(:share).message
          end
        end
        context "min params" do
          setup do
            get :new, :u => @uri, :t => @title, :m => @message
          end
          should_not_set_the_flash
          should_respond_with :success
          should_render_template :new
          should "setup the share" do
            assert_equal @uri, assigns(:share).uri
            assert_equal @title, assigns(:share).title
            assert_equal @message, assigns(:share).message
          end
        end
      end

      context "GET index no user specified" do
        setup do
          @user.shares.create(Factory.attributes_for(:share))
          @user.shares.create(Factory.attributes_for(:share))
          get :index, :format => 'html'
        end
        should_not_set_the_flash
        should_respond_with :success
        should_render_template :index
      end
    
      context "GET index user specified" do
        setup do
          @user.shares.create(Factory.attributes_for(:share))
          @user.shares.create(Factory.attributes_for(:share))
          get :index, :user_id => @user.to_param, :format => 'html'
        end
        should_not_set_the_flash
        should_respond_with :success
        should_render_template :index
      end
      
      context "DELETE to destroy" do
        setup do
          @share = @user.shares.create(Factory.attributes_for(:share))
          @no_delete_share = Factory(:share)
        end
        should "delete share" do
          assert_difference "Share.count", -1 do
            delete :destroy, { :id => @share.to_param, :format => 'json' }
            assert @response.body.include?(I18n.t('muck.shares.share_removed'))
          end
        end
        should "not delete share" do
          assert_no_difference "Share.count" do
            delete :destroy, { :id => @no_delete_share.to_param, :format => 'json' }          
          end
        end
      end

    end

  end

end
