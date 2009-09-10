require File.dirname(__FILE__) + '/../test_helper'

class Muck::ActivitiesControllerTest < ActionController::TestCase

  tests Muck::ActivitiesController

  context "activities controller - anonymous" do
    context "on GET to index" do
      setup do
        @user = Factory(:user)
        @activity = Factory(:activity, :template => 'status_update')
        @user.activities << @activity
      end
      context 'on GET to index (js)' do
        setup do
          get :index, :parent_type => @user.class, :parent_id => @user, :format => 'js', :latest_activity_id => @activity.to_param
        end
        should_respond_with :success
      end
    end
  end
  
  context "activities controller - logged in" do
    setup do
      activate_authlogic
      @user = Factory(:user)
      login_as @user
    end

    context "on GET to index" do
      setup do
        @activity = Factory(:activity, :template => 'status_update')
        @user.activities << @activity
      end
    
      context 'on GET to index (js)' do
        setup do
          get :index, :parent_type => @user.class, :parent_id => @user, :format => 'js', :latest_activity_id => @activity.to_param
        end
        should_respond_with :success
      end

      context 'on GET to index (js) no latest activity id' do
        setup do
          get :index, :parent_type => @user.class, :parent_id => @user, :format => 'js', :latest_activity_id => nil
        end
        should_respond_with :success
      end
    end

    context 'fail on POST to create (json)' do
      setup do
        post :create, :activity => { :content => 'test activity' }, :parent_type => @user.class.to_s, :parent_id => @user, :format => 'json'
      end      
      should_respond_with :success
      should_not_set_the_flash
      should "return create json errors" do
        json = ActiveSupport::JSON.decode(@response.body).symbolize_keys!
        assert !json[:success]
        assert_equal json[:message], I18n.t("muck.activities.create_error", :error => assigns(:activity).errors.full_messages.to_sentence)
      end
    end
        
    context 'on POST to create (json)' do
      setup do
        @activity_content = 'test content for my new activity'
        post :create, :activity => { :content => @activity_content, :template => 'status_update' }, :parent_type => @user.class, :parent_id => @user, :format => 'json'
      end      
      should_respond_with :success
      should_not_set_the_flash
      should "return valid create json" do
        json = ActiveSupport::JSON.decode(@response.body).symbolize_keys!
        assert json[:success]
        assert !json[:is_status_update]
        assert json[:html].include?(@activity_content)
        assert_equal json[:message], I18n.t("muck.activities.created")
      end
    end
       
    context 'on POST to create (js)' do
      setup do
        post :create, :activity => { :content => 'test activity' }, :parent_type => @user.class, :parent_id => @user, :format => 'js'
      end      
      should_respond_with :success
      should_not_set_the_flash
    end
     
    context 'on POST to create' do
      setup do
        post :create, :activity => { :content => 'test activity' }, :parent_type => @user.class, :parent_id => @user
      end      
      should_redirect_to('show user page (user dashboard)') { @user }
    end

    context 'on DELETE to destroy' do
      setup do
        @activity = Factory(:activity, :source => @user)
        delete :destroy, :id => @activity.id
      end
      should_respond_with :redirect
      should_set_the_flash_to(I18n.t("muck.activities.item_removed"))
    end
  
    context 'on DELETE to destroy (js)' do
      setup do
        @activity = Factory(:activity, :source => @user, :is_status_update => false)
        delete :destroy, :id => @activity.id, :format => 'js'
      end
      should_respond_with :success
      should_not_set_the_flash
    end
    
    context 'on DELETE to destroy, status update (js)' do
      setup do
        @activity = Factory(:activity, :source => @user, :is_status_update => true)
        delete :destroy, :id => @activity.id, :format => 'js'
      end
      should_respond_with :success
      should_not_set_the_flash
    end
    
    context 'on DELETE to destroy (json)' do
      setup do
        @activity = Factory(:activity, :source => @user, :is_status_update => false)
        delete :destroy, :id => @activity.id, :format => 'json'
      end
      should_respond_with :success
      should_not_set_the_flash
      should "return valid delete json" do
        json = ActiveSupport::JSON.decode(@response.body).symbolize_keys!
        assert json[:success]
        assert !json[:is_status_update]
        assert json[:html].blank?
        assert_equal json[:message], I18n.t("muck.activities.item_removed")
      end
    end
    
    context 'on DELETE to destroy, status update (json)' do
      setup do
        @activity = Factory(:activity, :source => @user, :is_status_update => true)
        delete :destroy, :id => @activity.id, :format => 'json'
      end
      should_respond_with :success
      should_not_set_the_flash
      should "return valid delete json" do
        json = ActiveSupport::JSON.decode(@response.body).symbolize_keys!
        assert json[:success]
        assert json[:is_status_update]
        assert json[:html].length > 0
        assert_equal json[:message], I18n.t("muck.activities.item_removed")
      end
    end
  end
  
end
