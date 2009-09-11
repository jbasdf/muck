require File.dirname(__FILE__) + '/../test_helper'

class Muck::VisitsControllerTest < ActionController::TestCase

  tests Muck::VisitsController

  context "visits controller" do

    context "GET show" do
      setup do
        @entry = Factory(:entry)
        get :show, :id => @entry.to_param, :format => 'html'
      end
      should_not_set_the_flash
      should_respond_with :success
      should_render_template :show
    end

  end

end