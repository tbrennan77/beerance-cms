class ChargesController < ApplicationController
  before_filter :set_plan, only: %w{create}
  before_filter :require_user

  def new
  end

  def create
    begin
    customer = Stripe::Customer.create(
      :card  => params[:stripeToken],
      :plan  => @plan_type,
      :email => current_user.username
    )
    set_stripe_id customer.id

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => 'Rails Stripe customer',
      :currency    => 'usd'
    )


    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_charge_path
    end
    redirect_to profile_path
  end

  def cancel_subscription
    cancel = `curl https://api.stripe.com/v1/customers/#{current_user.stripe_customer_id}/subscription \
   -u #{Stripe.api_key}: \
   -X DELETE`
   redirect_to profile_path, notice: 'We are so sad to see you go :('
  end

  private

  def set_plan
    # Amount in cents
    case params[:plan_type].to_i
    when 1
      @amount = 500
      @plan_type = "level_1"
    when 2
      @amount = 1500
      @plan_type = "level_2"
    when 3
      @amount = 3000
      @plan_type = "level_3"
    else
      flash[:error] = "You need to select a plan."
      redirect_to new_charge_path
    end
  end

  def set_stripe_id(customer_id)
    current_user.stripe_customer_id = customer_id
    current_user.save
  end
end