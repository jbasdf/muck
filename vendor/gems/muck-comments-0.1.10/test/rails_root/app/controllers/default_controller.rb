class DefaultController < ApplicationController
  
  def index
    @user = User.create
  end
  
end