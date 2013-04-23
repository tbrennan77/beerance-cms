Rails.configuration.stripe = {
  :publishable_key => "pk_test_weoNBbbyjlvVH6byhDE992nq",
  :secret_key      => "sk_test_Yla7t2GFVTDzgCO3s8OlUaaF"
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
STRIPE_PUBLIC_KEY = Rails.configuration.stripe[:publishable_key]