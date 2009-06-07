class Admin::DomainThemesController < Admin::Disguise::DomainThemesController
  before_filter :login_required
end