class Recommender::DefaultController < ApplicationController

  def widgets
    respond_to do |format|
      format.html { render :template => 'default/widgets' }
    end
  end
  
  def tour
    respond_to do |format|
      format.html { render :template => 'default/tour' }
    end
  end

end
