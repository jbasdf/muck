class Admin::ThemesController < Admin::Disguise::ThemesController
  before_filter :login_required
  before_filter :admin_access_required
end