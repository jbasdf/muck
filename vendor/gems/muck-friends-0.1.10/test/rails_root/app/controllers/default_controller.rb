class DefaultController < ApplicationController
  before_filter :get_user
  
  def get_user
    # a bit of a hack but this grabs the 'other_user' stubbed out in the test and makes @user available to helper methods
    @user = other_user
  end
  
end