class BarEntitiesController < ApplicationController
  before_filter :require_user
  before_filter :confirm_correct_user, except: %w{new index create}
  before_filter :set_times, only: %w{create update}  

  def new  
    @bar_entity = BarEntity.new    
  end  

  def index
    @bar_entities = BarEntity.all#where bar_owner_id: current_user.id
    redirect_to new_bar_entity_path if @bar_entities.blank?    
  end
    
  def create
    params[:bar_entity].assert_valid_keys %w{bar_name bar_phone bar_url bar_addr1 bar_addr2 bar_city bar_state bar_zip hours_mon hours_tues hours_wed hours_thur hours_fri hours_sat hours_sun}
    @bar_entity = BarEntity.new params[:bar_entity]
    @bar_entity.set_bar_owner current_user.id
    @bar_entity.set_geo_location

    if @bar_entity.save
      respond_to do |format|
        format.html { redirect_to bar_entities_path, :notice => "Added Bar!" }
        format.js
      end

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
    bar_entity = BarEntity.find params[:id]
    bar_entity.destroy
    @id = params[:id]
    respond_to do |format|
      format.html {redirect_to profile_path}
      format.js
    end
  end

  private

  def confirm_correct_user
    redirect_to log_out_path unless BarEntity.find(params[:id]).bar_owner_id == current_user.id
  end

  def set_times
    params[:bar_entity][:hours_mon]  = cat_times params[:bar_entity][:mon_start], params[:bar_entity][:mon_end]
    params[:bar_entity][:hours_tues] = cat_times params[:bar_entity][:tue_start], params[:bar_entity][:tue_end]
    params[:bar_entity][:hours_wed]  = cat_times params[:bar_entity][:wed_start], params[:bar_entity][:wed_end]
    params[:bar_entity][:hours_thur] = cat_times params[:bar_entity][:thu_start], params[:bar_entity][:thu_end]
    params[:bar_entity][:hours_fri]  = cat_times params[:bar_entity][:fri_start], params[:bar_entity][:fri_end]
    params[:bar_entity][:hours_sat]  = cat_times params[:bar_entity][:sat_start], params[:bar_entity][:sat_end]
    params[:bar_entity][:hours_sun]  = cat_times params[:bar_entity][:sun_start], params[:bar_entity][:sun_end]
    
    [:mon_start, :mon_end, :tue_start, :tue_end, :wed_start, :wed_end, :thu_start, :thu_end, :fri_start, :fri_end, :sat_start, :sat_end, :sun_start, :sun_end].each do |key|
      params[:bar_entity].delete key
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
