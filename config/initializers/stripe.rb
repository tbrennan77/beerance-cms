stripe_settings = YAML.load(File.new("config/stripe.yml").read)[Rails.env]

Rails.configuration.stripe = {
  # Replace these with your Stripe.com keys
  :publishable_key => stripe_settings['stripe_publishable_key'],
  :secret_key      => stripe_settings['stripe_secret_key']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
STRIPE_PUBLIC_KEY = Rails.configuration.stripe[:publishable_key]
