class BarEntitiesController < ApplicationController
  before_filter :require_user
  before_filter :confirm_correct_user, except: %w{new index create}
  before_filter :set_times, only: %w{create update}  

  def new  
    @bar_entity = BarEntity.new    
  end  

  def index
    @bar_entities = BarEntity.where bar_owner_id: current_user.id
    redirect_to new_bar_entity_path unless current_user.bars?
  end
    
  def create
    params[:bar_entity].assert_valid_keys %w{bar_name stripe_card_token subscription_plan_id bar_phone bar_url bar_addr1 bar_addr2 bar_city bar_state bar_zip hours_mon hours_tues hours_wed hours_thur hours_fri hours_sat hours_sun}
    @bar_entity = BarEntity.new params[:bar_entity]
    @bar_entity.set_bar_owner current_user.id
    @bar_entity.set_geo_location

    if @bar_entity.save_with_payment
      redirect_to bar_entities_path, :notice => "Added Bar"
    else  
      render "new"  
    end  
  end

  def edit
    @bar_entity = BarEntity.find(params[:id])
  end

  def update
    params[:bar_entity].assert_valid_keys %w{bar_name bar_phone bar_url bar_addr1 bar_addr2 bar_city bar_state bar_zip hours_mon hours_tues hours_wed hours_thur hours_fri hours_sat hours_sun}
    @bar_entity = BarEntity.find(params[:id])

    if @bar_entity.update_attributes params[:bar_entity]     
      @bar_entity.ensure_fields
      @bar_entity.save
      redirect_to bar_entities_path, notice: 'Updated Bar'
    else
      render :edit
    end
  end

  def destroy
    #bar_entity = BarEntity.find params[:id]
    #bar_entity.destroy
    #redirect_to bar_entities_path, notice: 'Deleted Bar'
  end

  private

  def confirm_correct_user
    redirect_to log_out_path unless BarEntity.find(params[:id]).bar_owner_id == current_user.id
  end

  def set_times
    %w{mon tues wed thur fri sat sun}.each do |d|
      params[:bar_entity]["hours_#{d}"] = cat_times(params[:bar_entity]["#{d}_start"], params[:bar_entity]["#{d}_end"])
      params[:bar_entity].delete("#{d}_start")
      params[:bar_entity].delete("#{d}_end")
    end
  end

  def cat_times(open, close)
    if open == "Closed" || close == "Closed"
      "Closed"
    else
      "#{open} - #{close}"
    end
  end  
end
