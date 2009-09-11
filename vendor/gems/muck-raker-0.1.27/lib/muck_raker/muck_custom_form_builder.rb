module MuckRakerCustomFormBuilder

  def service_select(method, options = {}, html_options = {}, additional_service = nil)
    @services ||= (additional_service ? [additional_service] : []) + Service.find(:all, :order => 'name asc')
    self.menu_select(method, I18n.t('muck.raker.choose_service'), @services, options.merge(:prompt => I18n.t('muck.raker.select_service_prompt'), :wrapper_id => 'muck_raker_services_container'), html_options.merge(:id => 'muck_raker_services'))
  end
  
  def muck_raker_service_select(method, options = {}, html_options = {}, additional_service = nil)
    @services ||= (additional_service ? [additional_service] : []) + Service.find(:all, :order => 'name asc', :conditions => "services.id IN (#{MuckRaker::Services::RSS}, #{MuckRaker::Services::OAI})")
    self.menu_select(method, I18n.t('muck.raker.type_of_metadata'), @services, options.merge(:prompt => I18n.t('muck.raker.type_of_metadata'), :wrapper_id => 'muck_raker_services_container'), html_options.merge(:id => 'muck_raker_services'))
  end

  # creates a select control with languages specific to muck raker.  Default id is 'muck_raker_languages'.  If 'retain' is passed for the class value the value of this
  # control will be written into a cookie with the key 'languages'.
  def muck_raker_language_select(method, options = {}, html_options = {}, additional_language = nil)
    @languages ||= (additional_language ? [additional_language] : []) + Language.find(:all, :order => 'name asc', :conditions => 'languages.muck_raker_supported = true')
    self.menu_select(method, I18n.t('muck.engine.choose_language'), @languages, options.merge(:prompt => I18n.t('muck.engine.select_language_prompt'), :wrapper_id => 'muck_raker_languages-container'), html_options.merge(:id => 'muck_raker_languages'))
  end
  
end

MuckCustomFormBuilder.send :include, MuckRakerCustomFormBuilder