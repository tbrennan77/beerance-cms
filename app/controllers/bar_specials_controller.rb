class BarSpecialsController < ApplicationController
  before_filter :require_user
  before_filter :confirm_correct_user, except: %w{new toggle_beerance}
  before_filter :instantiate_new_special, except: %w{destroy}

  def new    
  end
    
  def create      
    bar_special = BarSpecials.new params[:bar_specials]    
    if bar_special.save_and_format
      respond_to do |f|
        f.html {redirect_to profile_path, :notice => "Added Special!"}
        f.js { flash.now.notice = "Added Special!"}
      end
    else  
      render "new"  
    end  
  end

  def update    
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

  def toggle_beerance
    @special = current_user.specials.find { |d| d.id == params[:id] }    
    if @special.toggle_activation
      respond_to do |format|
        format.js   { flash.now.notice = "Updated Special" }
        format.html { redirect_to profile_path, notice: 'Updated Special' }
      end
    end
  end

  private

  def instantiate_new_special
    @bar_special = BarSpecials.new
  end

  def confirm_correct_user
    redirect_to log_out_path unless BarEntity.find(params[:bar_specials][:bar_id]).bar_owner_id == current_user.id
  end

  def bar_special_params
    params[:bar_specials][:sale_price] = params[:bar_specials][:sale_price].to_f
    params[:bar_specials][:beer_color] = params[:bar_specials][:beer_color].to_i
    params[:bar_specials][:beer_size]  = params[:bar_specials][:beer_size].to_i
    params[:bar_specials]
  end  
end
