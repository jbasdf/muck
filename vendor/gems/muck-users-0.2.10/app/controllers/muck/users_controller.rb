class Muck::UsersController < ApplicationController
  unloadable

  ssl_required :show, :new, :edit, :create, :update
  before_filter :not_logged_in_required, :only => [:new, :create] 
  before_filter :login_required, :only => [:show, :edit, :update, :welcome]
  before_filter :check_administrator_role, :only => [:enable]

  def show
    @user = User.find(params[:id]) if params[:id]
    @user ||= current_user
    if @user == current_user || admin?
      @page_title = @user.to_param
      standard_response('show')
    else
      redirect_to public_user_path(@user)
    end
  end
  
  def welcome
    @page_title = t('muck.users.welcome')
    @user = User.find(params[:id])
    respond_to do |format|
      format.html { render :template => 'users/welcome' }
    end
  end
  
  def activation_instructions
    @page_title = t('muck.users.welcome')
    @user = User.find(params[:id])
    respond_to do |format|
      format.html { render :template => 'users/activation_instructions' }
    end
  end

  def new
    @page_title = t('muck.users.register_account', :application_name => GlobalConfig.application_name)
    @user = User.new
    standard_response('new')
  end
  
  def edit
    @page_title = t('muck.users.update_profile')
    @user = admin? ? User.find(params[:id]) : current_user
    respond_to do |format|
      format.html { render :template => 'users/edit' }
    end
  end
    
  def create
    @page_title = t('muck.users.register_account', :application_name => GlobalConfig.application_name)
    cookies.delete :auth_token
    @user = User.new(params[:user])

    if GlobalConfig.use_recaptcha
      if !(verify_recaptcha(@user) && @user.valid?)
        raise ActiveRecord::RecordInvalid, @user
      end
    end

    if GlobalConfig.automatically_activate
      if GlobalConfig.automatically_login_after_account_create
        if @user.save
          @user.activate!
          UserSession.create(@user)
          send_welcome_email
          flash[:notice] = t('muck.users.thanks_sign_up')
          after_create_response(true, signup_complete_path(@user))
        else
          after_create_response(false)
        end
      else
        if @user.save_without_session_maintenance
          @user.activate!
          send_welcome_email
          flash[:notice] = t('muck.users.thanks_sign_up_login')
          after_create_response(true, signup_complete_login_required_path(@user))
        else
          after_create_response(false)
        end
      end
    else
      if @user.save_without_session_maintenance
        @user.deliver_activation_instructions!
        flash[:notice] = t('muck.users.thanks_sign_up_check')
        after_create_response(true, signup_complete_activation_required_path(@user))
      else
        after_create_response(false)
      end
    end
  end

  def update
    @title = t("users.update_profile")
    @user = admin? ? User.find(params[:id]) : User.find(current_user)
    if @user.update_attributes(params[:user])
      flash[:notice] = t("muck.users.user_update")
      after_update_response(true)
    else
      after_update_response(false)
    end
  end

  def destroy
    return unless admin? || GlobalConfig.let_users_delete_their_account
    @user = admin? ? User.find(params[:id]) : User.find(current_user)
    if @user.destroy
      flash[:notice] = t("muck.users.user_account_deleted")
    end
    after_destroy_response
  end

  def is_login_available
    result = t('muck.users.username_not_available')
    if params[:user_login].nil?
      result = ''
    elsif params[:user_login].empty?
      result = t('muck.users.login_empty')
    elsif !User.login_exists?(params[:user_login])
      @user = User.new(:login => params[:user_login])
      if !@user.validate_attributes(:only => [:login])
        result = t('muck.users.invalid_username')
        @user.errors.full_messages.each do |message|
          if !message.include? 'blank'
            result += "<br />#{message}"
          end
        end
      else
        result = t('muck.users.username_available')
      end
    end
    respond_to do |format|
      format.html { render :text => result}
    end
  end

  def is_email_available
    if params[:user_email].nil?
      result = ''
    elsif params[:user_email].empty?
      result = t('muck.users.email_empty')
    elsif !User.email_exists?(params[:user_email])
      valid, errors = valid_email?(params[:user_email])
      if valid
        result = t('muck.users.email_available')
      else
        result = t('muck.users.email_invalid')
      end
    else
      recover_password_prompt = render_to_string :partial => 'users/recover_password_via_email_link', :locals => { :email => params[:user_email] }
      result = t('muck.users.email_not_available', :reset_password_help => recover_password_prompt)
    end
    respond_to do |format|
      format.html { render :text => result }
    end
  end

  protected 

  def send_welcome_email
    begin
      @user.deliver_welcome_email
    rescue Net::SMTPAuthenticationError => ex
      # TODO figure out what to do when email fails
      # @user.no_welcome_email = 
    end
  end

  def valid_email?(email)
    user = User.new(:email => email)
    user.valid?
    if user.errors[:email]
      [false, user.errors[:email]]
    else
      [true, '']
    end
  end
  
  def standard_response(template)
    respond_to do |format|
      format.html { render :template => "users/#{template}" }
      format.xml { render :xml => @user }
    end
  end
  
  def after_create_response(success, local_uri = '')
    if success
      respond_to do |format|
        format.html { redirect_to local_uri }
        format.xml { render :xml => @user, :status => :created, :location => user_url(@user) }
      end
    else
      respond_to do |format|
        format.html { render :template => "users/new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # override redirect by adding :redirect_to as a hidden field in your form or as a url param
  def after_update_response(success)
    if success
      respond_to do |format|
        format.html do
          get_redirect_to do
            redirect_to admin? ? profile_path(@user) : user_path(@user)
          end
        end
        format.xml{ head :ok }
      end
    else
      respond_to do |format|
        format.html { render :template => 'users/edit' }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # override redirect by adding :redirect_to as a hidden field in your form or as a url param
  def after_destroy_response
    respond_to do |format|
      format.html do
        flash[:notice] = t('muck.users.login_out_success')
        get_redirect_to do
          redirect_to(login_url)
        end
      end
      format.xml { head :ok }
    end
  end
  
  def permission_denied
    flash[:notice] = t('muck.users.permission_denied')
    respond_to do |format|
      format.html do
        redirect_to user_path(current_user)
      end
    end
  end

end
