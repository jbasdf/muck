class Admin::DomainThemesController < Admin::Disguise::DomainThemesController
  before_filter :login_required
  before_filter :admin_access_required
end