class BarSpecialsController < ApplicationController
  WRITABLE_ATTRIBUTES = %w{ bar_id special_description sale_price beer_color beer_size }

  before_filter :require_user
  before_filter :confirm_correct_user, except: %w{new end_beerance reactivate_beerance}
  before_filter :confirm_correct_user_for_activation, only: %w{end_beerance reactivate_beerance}

  def new  
    @bar_special = BarSpecials.new    
  end  
    
  def create  
    params[:bar_specials].assert_valid_keys WRITABLE_ATTRIBUTES
    @bar_special = BarSpecials.new params[:bar_specials]
    if @bar_special.save
      redirect_to profile_path, :notice => "Added Special!"  
    else  
      render "new"  
    end  
  end

  def destroy
    bar_entity = BarSpecials.find params[:id]
    bar_entity.destroy
    redirect_to profile_path
  end

  def end_beerance
    special = BarSpecials.find params[:id]
    special.end_special
    if special.save
      redirect_to profile_path, notice: 'Ended beerance'
    else
      flash[:error] = "Something went wrong"
      redirect_to profile_path
    end
  end

  def reactivate_beerance
    special = BarSpecials.find params[:id]
    special.reactivate_special
    if special.save
      redirect_to profile_path, notice: 'Reactivated Beerance'
    else
      flash[:error] = "Something went wrong"
      redirect_to profile_path
    end
  end

  def confirm_correct_user
    redirect_to log_out_path unless BarEntity.find(params[:bar_specials][:bar_id]).bar_owner_id == current_user.id
  end

  def confirm_correct_user_for_activation
    special = BarSpecials.find params[:id]
    redirect_to log_out_path unless special.bar.user.id == current_user.id
  end

end
