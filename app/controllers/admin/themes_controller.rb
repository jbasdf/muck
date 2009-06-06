class Admin::ThemesController < Admin::Disguise::ThemesController
  before_filter :login_required
end