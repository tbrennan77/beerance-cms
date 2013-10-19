# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Beerance::Application.config.secret_token = if Rails.env.development? or Rails.env.test?
  ('x' * 30) # meets minimum requirement of 30 chars long
else
  '33be17f6dfc0e4b20489aca3652e183eb750710adec7d525de1ef8708f7f34d592f0abd0cc9f5f07bb0334a7797e1df55591cc5ff7b06d9786f8ac12c12d8b50'
end

Beerance::Application.config.secret_key_base = if Rails.env.development? or Rails.env.test?
  ('x' * 30) # meets minimum requirement of 30 chars long
else
  '33be17f6dfc0e4b20489aca3652e183eb750710adec7d525de1ef8708f7f34d592f0abd0cc9f5f07bb0334a7797e1df55591cc5ff7b06d9786f8ac12c12d8b50'
end
