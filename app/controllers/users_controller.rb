class UsersController < Muck::UsersController
  before_filter :store_location
  
end