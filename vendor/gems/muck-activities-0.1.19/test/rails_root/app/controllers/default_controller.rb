class DefaultController < ApplicationController
  
  def index
    @user = current_user
  end
  
end