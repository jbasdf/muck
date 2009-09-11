require 'muck_raker/muck_custom_form_builder'
require 'muck_raker/services'

ActionController::Base.send :helper, MuckRakerHelper
ActionController::Base.send :helper, MuckRakerFeedsHelper
ActionController::Base.send :helper, MuckRakerServicesHelper

ActiveRecord::Base.class_eval { include ActiveRecord::Acts::MuckFeedParent }
ActiveRecord::Base.class_eval { include ActiveRecord::Acts::MuckRakerComment }
ActiveRecord::Base.class_eval { include ActiveRecord::Acts::MuckRakerShare }
ActiveRecord::Base.class_eval { include ActiveRecord::Acts::MuckFeedOwner }


I18n.load_path += Dir[ File.join(File.dirname(__FILE__), '..', 'locales', '*.{rb,yml}') ]

Mime::Type.register "application/rdf+xml", :rdf
Mime::Type.register "text/javascript", :pjs