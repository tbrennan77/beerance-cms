class BarSpecialsController < ApplicationController
  before_filter :require_user
  before_filter :confirm_correct_user, except: %w{new}

  def new  
    @bar_special = BarSpecial.new    
  end  
    
  def create  
    params[:bar_special].assert_valid_keys %w{ bar_id special_description sale_price expiration_date beer_color }
    @bar_special = BarSpecial.new(params[:bar_special])    
    
    if @bar_special.save
      redirect_to profile_path, :notice => "Added Special!"  
    else  
      render "new"  
    end  
  end

  def destroy
    bar_entity = BarSpecial.find params[:id]
    bar_entity.destroy
    redirect_to profile_path
  end

  def confirm_correct_user
    redirect_to log_out_path unless BarEntity.find(params[:bar_special][:bar_id]).bar_owner_id == current_user.id
  end

end
