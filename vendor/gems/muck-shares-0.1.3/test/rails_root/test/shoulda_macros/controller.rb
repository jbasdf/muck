module MuckControllerMacros

  def should_require_login(*args)
    args = Hash[*args]
    login_url = args.delete :login_url
    args.each do |action, verb|
      should "Require login for '#{action}' action" do
        if [:put, :delete].include?(verb) # put and delete require an id even if it is a bogus one
          send(verb, action, :id => 1)
        else
          send(verb, action)
        end
        assert_redirected_to(login_url)
      end
    end
  end

  def should_require_role(role, redirect_url, *actions)
    actions.each do |action|
      should "require role for '#{action}' action" do
        get(action)
        ensure_flash(/permission/i)
        assert_response :redirect
      end
    end
  end
  
  #from: http://blog.internautdesign.com/2008/9/11/more-on-custom-shoulda-macros-scoping-of-instance-variables
  def should_not_allow action, object, url= "/login", msg=nil
    msg ||= "a #{object.class.to_s.downcase}" 
    should "not be able to #{action} #{msg}" do
      object = eval(object, self.send(:binding), __FILE__, __LINE__)
      get action, :id => object.id
      assert_redirected_to url
    end
  end

  def should_allow action, object, msg=nil
    msg ||= "a #{object.class.to_s.downcase}" 
    should "be able to #{action} #{msg}" do
      object = eval(object, self.send(:binding), __FILE__, __LINE__)
      get action, :id => object.id
      assert_response :success
    end
  end

end

ActionController::TestCase.extend(MuckControllerMacros)
