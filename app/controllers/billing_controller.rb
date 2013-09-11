class BillingController < ApplicationController
  before_filter :require_user

  def index 
    redirect_to new_bar_entity_path unless current_user.bars?   
  end

  def invoices
    @bar = find_current_users_bar params[:id]
  end

  def show
    @bar = find_current_users_bar params[:id]    
  end

  def show_invoice
    if current_user.admin?
      @invoice = Stripe::Invoice.retrieve params[:id]
    elsif BarEntity.where(stripe_customer_id: @invoice.customer).first.user_id == current_user.id
      @invoice = Stripe::Invoice.retrieve params[:id]
    else
      redirect_to log_out_path
    end
  end

  def update_plan
    @bar = find_current_users_bar params[:id]    
    plan = SubscriptionPlan.find(params[:subscription_plan_id])
    @bar.update_plan(plan) unless @bar.subscription_plan_id == plan.id
    redirect_to show_billing_path(@bar.id), notice: 'Updated plan'
  end

  def edit_plan
    @bar = find_current_users_bar params[:id]
  end

  def edit_card
    @bar = find_current_users_bar params[:id]
  end

  def update_card
    @bar = find_current_users_bar params[:id]
    if @bar.update_card(params[:stripe_card_token])
      redirect_to show_billing_path(@bar.id), notice: 'Updated Card Info'
    else
      render 'edit_card'
    end      
  end

  def cancel_subscription
    @bar = find_current_users_bar params[:id]
    @bar.cancel_subscription
    @bar.update_attributes subscription_plan_id: ''   
    redirect_to show_billing_path(@bar.id), notice: 'We are so sad to see you go :('
  end

  def find_current_users_bar(id)
    if current_user.admin?
      BarEntity.find(id)
    else
      current_user.bars.where(objectId: id).first
    end
  end
end
