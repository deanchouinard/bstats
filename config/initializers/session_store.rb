# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_bstats_session',
  :secret      => '7ddd7fd5cecda33f8a2a8e77631734ade5f63b81b3e4247729fd40f33a85a24d96315852d64b526f735ee652b397185b75d718423efd8302ac437d11cf140ae2'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
