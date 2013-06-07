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

  def update
    bs = BarSpecials.find params[:id]
    if bs.update_attributes params[:bar_specials]  
      get_specials    
      respond_to do |format|
        format.js { flash[:notice] = ""; }
        format.html
      end
    else
      respond_to do |format|
        format.js { flash[:error] = "Something went wrong!"; }
        format.html
      end
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
      respond_to do |format|
        format.js
        format.html {redirect_to profile_path, notice: 'Ended beerance'}
      end      
    else
      flash[:error] = "Something went wrong"
      redirect_to profile_path
    end
  end

  def reactivate_beerance
    special = BarSpecials.find params[:id]
    special.reactivate_special
    if special.save
      respond_to do |format|
        format.js
        format.html { redirect_to profile_path, notice: 'Reactivated Beerance'}
      end
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

def get_specials
    @bar_entities = BarEntity.where bar_owner_id: current_user.id
    @active_specials = []
    @inactive_specials = []
    
    @bar_entities.each do |be|
      be.bar_specials.each do |s|
        if s.active?
          @active_specials << s
        else
          @inactive_specials << s
        end
      end
    end
  end
end
