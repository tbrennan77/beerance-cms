class BarsController < ApplicationController
  before_filter :require_user  

  def new  
    @bar_entity = Bar.new    
  end  

  def index
    @bar_entities = current_user.bars.all
    redirect_to new_bar_entity_path if @bar_entities.blank?
  end
    
  def create    
    @bar_entity = Bar.new bar_params
    @bar_entity.set_bar_owner(current_user.id)

    if @bar_entity.save_with_payment
      redirect_to bar_entities_path, :notice => "Added Bar"
    else  
      render "new"  
    end  
  end

  def edit
    @bar_entity = current_user.bars.where(objectId: params[:id]).first
  end

  def update    
    @bar_entity = current_user.bars.where(objectId: params[:id]).first

    if @bar_entity.update_attributes bar_params
      @bar_entity.save
      redirect_to bar_entities_path, notice: 'Updated Bar'
    else
      render :edit
    end
  end

  private

  def bar_params
    params.require(:bar).permit(:name, :stripe_card_token, :subscription_plan_id, :phone, :url, :addr1, :addr2, :city, :state, :zip, :hours_mon, :hours_tues, :hours_wed, :hours_thur, :hours_fri, :hours_sat, :hours_sun)
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
