require File.dirname(__FILE__) + '/../test_helper'

class Muck::UsersControllerTest < ActionController::TestCase

  tests Muck::UsersController
  
  should_require_login :welcome => :get, :edit => :get, :login_url => '/login'
  
  context "configuration tests" do
    teardown do
      GlobalConfig.automatically_activate = false
      GlobalConfig.automatically_login_after_account_create = false
    end
    
    context "automatically activate account and log user in. " do
      setup do
        GlobalConfig.automatically_activate = true
        GlobalConfig.automatically_login_after_account_create = true
      end
      context "on POST to :create" do
        setup do
          post_create_user
        end
        should_redirect_to("sign up complete path") { signup_complete_path(assigns(:user)) }
        should "activate user" do
          assert assigns(:user).active? == true, "user was not activated"
        end
        should "be logged in" do
          user_session = UserSession.find
          assert user_session, "user is not logged in"
        end
      end
      context "on POST to :create with bad login (space in login name)" do
        setup do
          post_create_user(:login => 'test guy')
        end
        should_respond_with :success
        should_render_template :new
        should "assign an error to the login field" do
          assert assigns(:user).errors.on(:login), "no errors were assign on login field"
        end
      end
    end
  
    context "automatically activate account do not log user in" do
      setup do
        GlobalConfig.automatically_activate = true
        GlobalConfig.automatically_login_after_account_create = false
      end
      context "on POST to :create" do  
        setup do
          post_create_user 
        end                             
        should_redirect_to("signup complete login required path") { signup_complete_login_required_path(assigns(:user)) } 
      end    
      context "on POST to :create with bad login (space in login name)" do
        setup do
          post_create_user(:login => 'test guy')
        end
        should_respond_with :success
        should_render_template :new
        should "assign an error to the login field" do
          assert assigns(:user).errors.on(:login), "no errors were assign on login field"
        end
      end   
    end
  
    context "do not auto activate. do not login after create" do
      setup do
        GlobalConfig.automatically_activate = false
        GlobalConfig.automatically_login_after_account_create = false
      end
      context "on POST to :create -- Allow signup. " do
        setup do
          post_create_user
        end                                
        should_redirect_to("activation required information page") { signup_complete_activation_required_path(assigns(:user)) }
      end
      context "on POST to :create -- require login on signup. " do
        setup do
          post_create_user :login => ''
        end
        should_respond_with :success
        should_render_template :new
        should "assign an error to the login field" do
          assert assigns(:user).errors.on(:login) 
        end                                       
      end
      context "on POST to :create with bad login (space in login name)" do
        setup do
          post_create_user(:login => 'test guy')
        end
        should_respond_with :success
        should_render_template :new
        should "assign an error to the login field" do
          assert assigns(:user).errors.on(:login) 
        end
      end
      context "on POST to :create -- require password on signup. " do
        setup do 
          post_create_user(:password => nil)
        end
        should_respond_with :success
        should_render_template :new
        should "assign an error to the password field" do
          assert assigns(:user).errors.on(:password) 
        end                                       
      end
      context "on POST to :create -- require password confirmation on signup. " do
        setup { post_create_user(:password_confirmation => nil) }
        should_respond_with :success
        should_render_template :new
          
        should "assign an error to the password confirmation field" do
          assert assigns(:user).errors.on(:password_confirmation) 
        end                                       
      end
      context "on POST to :create -- require email on signup. " do
        setup { post_create_user(:email => nil) }
        should_respond_with :success
        should_render_template :new
        should "assign an error to the email field" do
          assert assigns(:user).errors.on(:email) 
        end                                       
      end
    end
  end
  
  context "logged in" do
    setup do
      activate_authlogic
      @user = Factory(:user)
      login_as @user
    end
    
    context "on GET to :welcome" do
      setup do
        get :welcome, :id => @user.to_param
      end
      should_respond_with :success
      should_render_template :welcome
    end

    context "on GET to new (signup) while logged in" do
      setup do
        get :new
      end
      should_redirect_to("the logged in user's main user page") { user_url(@user) }
    end

    context "on GET to show" do
      setup do
        get :show
      end
      should_respond_with :success
      should_render_template :show
    end
    
    context "on GET to edit" do
      setup do
        get :edit, :id => @user.to_param
      end
      should_respond_with :success
      should_render_template :edit
    end
    
    context "on GET to edit logged in but wrong user" do
      setup do
        @other_user = Factory(:user)
        get :edit, :id => @other_user.to_param
      end
      should_respond_with :success
      should "set the user to the logged in user" do
        assert_equal assigns(:user), @user
      end
    end
    
    context "on PUT to :update" do
      setup do
        put_update_user(@user)
      end
      should_redirect_to("user path") { user_path(@user) }
    end
    
  end
  
  context "not logged in" do
    setup do
      assure_logout
    end
    context "on GET to :welcome" do
      setup do
        @user = Factory(:user)
        get :welcome, :id => @user.to_param
      end
      should_redirect_to("login") { login_path }
    end
    context "on GET to :activation_instructions" do
      setup do
        @user = Factory(:user)
        get :activation_instructions, :id => @user.to_param
      end
      should_respond_with :success
      should_render_template :activation_instructions
    end
    context "on GET to new (signup)" do
      setup do
        get :new
      end
      should_respond_with :success
      should_render_template :new
    end
    context "on GET to show" do
      setup do
        @user = Factory(:user)
        get :show
      end
      should_redirect_to("login") { login_path }
    end
    context "on GET to edit" do
      setup do
        @user = Factory(:user)
        get :edit, :id => @user.to_param
      end
      should_redirect_to("login") { login_path }
    end
    context "on PUT to :update" do
      setup do
        @user = Factory(:user)
        put_update_user(@user)
      end
      should_redirect_to("login") { login_path }
    end
  end

  context "on GET to is_email_available" do
    context "no params" do
      setup do
        get :is_email_available
      end
      should_respond_with :success
      should_render_text ""
    end
    context "empty email" do
      setup do
        get :is_email_available, :user_email => ''
      end
      should_respond_with :success
      should_render_text I18n.t('muck.users.email_empty')
    end
    context "valid email" do
      setup do
        get :is_email_available, :user_email => 'testdude1945@example.com'
      end
      should_respond_with :success
      should_render_text I18n.t('muck.users.email_available')
    end
    context "invalid email" do
      setup do
        get :is_email_available, :user_email => 'testdude1945@com'
      end
      should_respond_with :success
      should_render_text I18n.t('muck.users.email_invalid')
    end
    context "email not available" do
      setup do
        @user = Factory(:user)
        get :is_email_available, :user_email => @user.email
      end
      should_respond_with :success
      should_render_partial_text I18n.t('muck.users.email_not_available', :reset_password_help => '')
    end
  end
  
  
  def put_update_user(user, options = {})
    put :update,
      :id => user.id, 
      :user => { :login => 'testguy', 
        :email => rand(1000).to_s + 'testguy@example.com', 
        :password => 'testpasswrod', 
        :password_confirmation => 'testpasswrod', 
        :first_name => 'Ed',
        :last_name => 'Decker',
        :terms_of_service => true }.merge(options)
  end

  def post_create_user(options = {})
    post :create, 
      :user => { :login => 'testguy', 
        :email => rand(1000).to_s + 'testguy@example.com', 
        :password => 'testpasswrod', 
        :password_confirmation => 'testpasswrod', 
        :first_name => 'Ed',
        :last_name => 'Decker',
        :terms_of_service => true }.merge(options)
  end

end
