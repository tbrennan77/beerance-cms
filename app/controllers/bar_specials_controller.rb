class BarSpecialsController < ApplicationController
  before_filter :require_user
  before_filter :confirm_correct_user, except: %w{new}

  def new
    @bar_special = BarSpecials.new
  end
    
  def create      
    @bar_special = BarSpecials.new bar_special_params    
    if @bar_special.bar.subscription.active? && @bar_special.save
      respond_to do |f|
        f.html {redirect_to profile_path, :notice => "Added Special!"}
        f.js { flash.now.notice = "Added Special!"; @bar_special = BarSpecials.new}
      end
    else  
      render "new"  
    end  
  end

  def update    
    @bar_special = BarSpecials.new
    bs = BarSpecials.find params[:id]
    if bs.update_attributes( bar_special_params )
      respond_to do |format|
        format.js { flash.now.notice = "Updated Special" }        
      end
    else
      respond_to do |format|
        format.js   { flash.now.notice = bs.errors.full_messages.first}  
      end
    end
  end

  def destroy
    bar_entity = BarSpecials.find params[:id]
    bar_entity.destroy
    redirect_to profile_path
  end

  def confirm_correct_user
    redirect_to log_out_path unless BarEntity.find(params[:bar_specials][:bar_id]).bar_owner_id == current_user.id
  end

  def bar_special_params
    BarSpecials.format_attributes(params[:bar_specials])
  end
end
