# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_oe_session',
  :secret      => '1c25df83c0bba5fb83629f7ad736d0a2b04f1c7b147e5f3019a75e4b8a835f1abcddc717f76a84a2ab9da7b542aad9bc04a3e187d4a3e87fcba5b335cd7bdf0e'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
