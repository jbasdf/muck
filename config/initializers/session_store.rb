# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_muck_session',
  :secret      => '6d10491fb4c061ff33a7e39f8614225d45c71f8fc1842452531c669985798a08ad68f64271136ff4bef840a9a0356b49c8acd81ab4955046509da7940aecb4e9'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
