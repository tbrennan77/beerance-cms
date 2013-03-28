class BarSpecialsController < ApplicationController
  before_filter :require_user
  #before_filter :confirm_correct_user, except: %w{new index create}

  def index
    @bar_specials = BarSpecial.all
  end

  def show
    @bar_entity = BarSpecial.find params[:id]
  end

  def new  
    @bar_special = BarSpecial.new    
  end  
    
  def create  
    @bar_special = BarSpecial.new(params[:bar_special])    
    @bar_special.bar_location = ParseGeoPoint.new :latitude => 34.09300844216167, :longitude => -118.3780094460731
    if @bar_special.save
      redirect_to profile_path, :notice => "Added Special!"  
    else  
      render "new"  
    end  
  end

  def edit
    @bar_entity = BarSpecial.find(params[:id])
  end

  def update
    @bar_entity = BarSpecial.find(params[:id])
    params[:bar_entity].delete(:bar_owner_id)
    @bar_entity.update_attributes params[:bar_entity]     
    if @bar_entity.valid?
      @bar_entity.save
      redirect_to profile_path
    else
      render :edit
    end
  end

  def destroy
    bar_entity = BarSpecial.find params[:id]
    bar_entity.destroy
    redirect_to profile_path
  end

  def confirm_correct_user
    redirect_to logout_path unless BarSpecial.find(params[:id]).bar_owner_id == current_user.id
  end

end
