class BillingController < ApplicationController
  before_filter :require_user

  def index    
  end

  def show
    @bar = BarEntity.find params[:id]    
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
    @bar = BarEntity.find params[:id]    
    plan = SubscriptionPlan.find(params[:subscription_plan_id])
    @bar.update_plan(plan) unless @bar.subscription_plan_id == plan.id
    redirect_to show_billing_path(@bar.id), notice: 'Updated plan'
  end

  def edit_plan
    @bar = BarEntity.find params[:id]
  end

  def edit_card
    @bar = BarEntity.find params[:id]
  end

  def update_card
    @bar = BarEntity.find params[:id]
    if @bar.update_card(params[:stripe_card_token])
      redirect_to show_billing_path(@bar.id), notice: 'Updated Card Info'
    else
      render 'edit_card'
    end      
  end
end
