Rails.configuration.stripe = {
  # Replace these with your Stripe.com keys
  :publishable_key => ENV['stripe_publishable_key'],
  :secret_key      => ENV['stripe_secret_key']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
STRIPE_PUBLIC_KEY = Rails.configuration.stripe[:publishable_key]
