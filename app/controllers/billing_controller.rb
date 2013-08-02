class BillingController < ApplicationController
  before_filter :require_user
  before_filter :confirm_correct_user, except: %w{index show_invoice}


  def index 
    redirect_to new_bar_entity_path unless current_user.bars?   
  end

  def invoices
    @bar = BarEntity.find params[:id]
  end

  def show
    @bar = BarEntity.find params[:id]    
  end

  def show_invoice    
    @invoice = Stripe::Invoice.retrieve params[:id]
    
    if BarEntity.where(stripe_customer_id: @invoice.customer).first.bar_owner_id != current_user.id
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

  def cancel_subscription
    @bar = BarEntity.find params[:id]
    @bar.cancel_subscription
    @bar.update_attributes subscription_plan_id: ''   
    redirect_to show_billing_path(@bar.id), notice: 'We are so sad to see you go :('
  end

  def confirm_correct_user
    redirect_to log_out_path unless BarEntity.find(params[:id]).bar_owner_id == current_user.id
  end

  def confirm_correct_user_for_invoice

  end
end
