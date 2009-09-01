class IdentityFeedsController < Muck::IdentityFeedsController
  before_filter :login_required
end