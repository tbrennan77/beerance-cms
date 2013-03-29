class BarEntitiesController < ApplicationController
  before_filter :require_user
  before_filter :confirm_correct_user, except: %w{new index create}
  before_filter :confirm_number_of_bars, only: %w{new create}

  def new  
    @bar_entity = BarEntity.new  
  end  
    
  def create
    params[:bar_entity].assert_valid_keys %w{bar_name bar_phone bar_url bar_addr1 bar_addr2 bar_city bar_state bar_zip hours_mon hours_tues hours_wed hours_thur hours_fri hours_sat hours_sun}
    @bar_entity = BarEntity.new params[:bar_entity]
    @bar_entity.set_bar_owner current_user.id
    @bar_entity.set_geo_location

    if @bar_entity.save  
      redirect_to profile_path, :notice => "Added Bar!"  
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
    @bar_entity.ensure_fields

    if @bar_entity.valid?
      @bar_entity.update_attributes params[:bar_entity]     
      redirect_to profile_path, notice: 'Updated Bar'
    else
      render :edit
    end
  end

  def destroy
    bar_entity = BarEntity.find params[:id]
    bar_entity.destroy
    redirect_to profile_path
  end

  def confirm_correct_user
    redirect_to logout_path unless BarEntity.find(params[:id]).bar_owner_id == current_user.id
  end

  def confirm_number_of_bars
    redirect_to(profile_path, notice: "You have reached your maximum allowed bars.") if BarEntity.where(bar_owner_id: current_user.id).count > 0
  end
end
