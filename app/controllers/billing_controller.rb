class BillingController < ApplicationController
  before_filter :require_user

  def index
    @customer = Stripe::Customer.retrieve current_user.stripe_customer_id
  end

  def invoices
    @customer = Stripe::Customer.retrieve current_user.stripe_customer_id
  end

  def show_invoice
    @invoice = Stripe::Invoice.retrieve params[:id]
    if @invoice.customer != current_user.stripe_customer_id
      redirect_to log_out_path
    end
  end

  def update_plan
    plan = SubscriptionPlan.find(params[:subscription_plan_id])
    current_user.update_plan(plan) unless current_user.subscription_plan_id == plan.id
    redirect_to billing_overview_path
  end

  def update_card
    current_user.update_card(params[:stripe_card_token])
    redirect_to billing_overview_path, notice: 'Updated Card Info'
  end
end
