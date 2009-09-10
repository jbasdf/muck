class Muck::BlogsController < ApplicationController
  unloadable
  
  before_filter :setup_parent
  
  def index
    if !@parent.blank?
      @blogs = @parent.blogs.by_newest rescue nil
      @blog ||= @parent.blog rescue nil
      if @blog
        redirect_to url_for([@parent, :blog, :posts])
        return
      end
    end
    @blogs ||= Blog.by_newest
    respond_to do |format|
      format.html { render :template => 'blogs/index', :layout => 'popup' }
      format.pjs { render :template => 'blogs/index', :layout => false }
    end
  end
  
  # redirect to the posts for the given blog
  def show
    if @parent
      @blog = @parent.blog
      redirect_to url_for([@parent, :blog, :posts])
    else
      @blog ||= Blog.find(params[:id])
      redirect_to blog_posts_path(@blog)
    end
  end
  
  protected
    def setup_parent
      @parent = get_parent
    end
  
end
