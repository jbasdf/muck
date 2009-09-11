class Admin::Muck::ContentsController < ApplicationController
  unloadable
  
  def index
  end
  
  def edit
    @content = Content.find(params[:id])
    @title = @content.title
    respond_to do |format|
      format.html { render :template => 'contents/edit' }
    end
  end

end
