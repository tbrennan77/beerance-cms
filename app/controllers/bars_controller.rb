class BarsController < ApplicationController
  before_filter :require_user  

  def new  
    @bar = Bar.new    
  end  

  def index
    @bars = current_user.bars.all
    redirect_to new_bar_path if @bars.blank?
  end
    
  def create    
    @bar = current_user.bars.new(bar_params)
    if @bar.save_with_payment
      redirect_to bars_path, notice: 'Added Bar'
    else
      render :new
    end  
  end

  def edit
    @bar = current_user.bars.find(params[:id])
  end

  def update    
    @bar = current_user.bars.find(params[:id])
    if @bar.update_attributes(bar_params)      
      redirect_to bars_path, notice: 'Updated Bar'
    else
      render :edit
    end
  end

  private

  def bar_params
    params.require(:bar).permit(
      :name,
      :stripe_card_token,
      :subscription_plan_id,
      :phone,
      :url,
      :address,
      :address_2,
      :city,
      :state,
      :zip,
      :monday_start,
      :monday_end,
      :tuesday_start,
      :tuesday_end,
      :wednesday_start,
      :wednesday_end,
      :thursday_start,
      :thursday_end,
      :friday_start,
      :friday_end,
      :saturday_start,
      :saturday_end,
      :sunday_start,
      :sunday_end
    )
  end

  def set_times
    %w{mon tues wed thur fri sat sun}.each do |d|
      params[:bar_entity]["hours_#{d}"] = cat_times(params[:bar_entity]["#{d}_start"], params[:bar_entity]["#{d}_end"])
      params[:bar_entity].delete("#{d}_start")
      params[:bar_entity].delete("#{d}_end")
    end
  end

  def cat_times(open, close)
    (open == "Closed" || close == "Closed") ? "Closed" : "#{open} - #{close}"    
  end  
end
