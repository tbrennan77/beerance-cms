class BarSpecialsController < ApplicationController
  before_filter :require_user
  before_filter :confirm_correct_user, except: %w{new end_beerance reactivate_beerance}
  before_filter :confirm_correct_user_for_activation, only: %w{end_beerance reactivate_beerance}

  def new  
    @bar_special = BarSpecial.new    
  end  
    
  def create  
    params[:bar_special].assert_valid_keys %w{ bar_id special_description sale_price beer_color beer_size }
    @bar_special = BarSpecial.create params[:bar_special]
    if @bar_special
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

  def end_beerance
    special = BarSpecial.find params[:id]
    special.end_special
    special.save
    redirect_to profile_path
  end

  def reactivate_beerance
    special = BarSpecial.find params[:id]
    special.reactivate_special
    special.save
    redirect_to profile_path
  end

  def confirm_correct_user
    redirect_to log_out_path unless BarEntity.find(params[:bar_special][:bar_id]).bar_owner_id == current_user.id
  end

  def confirm_correct_user_for_activation
    special = BarSpecial.find params[:id]
    redirect_to log_out_path unless BarEntity.find(special.bar_id).bar_owner_id == current_user.id
  end

end
