module MuckUsersHelper
  
  # Render a basic user registration form
  def signup_form(user, redirect_to = nil)
    render :partial => 'users/signup_form', :locals => { :user => user, :redirect_to => redirect_to}
  end
  
  # Sign up javascript is not required but will add script to the sign up form which will make ajax calls
  # that indicate to the user whether or not the login and email they choose have already been taken.
  def signup_form_javascript
    render :partial => 'users/signup_form_javascript'
  end
  
end