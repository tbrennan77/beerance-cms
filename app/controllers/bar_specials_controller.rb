class BarSpecialsController < ApplicationController
  before_filter :require_user  
  before_filter :instantiate_new_special
  
  def create      
    bar_special = current_user.bar_specials.new bar_special_params
    if bar_special.save_with_parse
      respond_to do |f|
        f.html {redirect_to profile_path, notice: 'Added Special!'}
        f.js { flash.now.notice = 'Added Special!'}
      end    
    else
      respond_to do |f|
        f.html {redirect_to profile_path, notice: 'The form was invalid!'}
        f.js { flash.now.notice = 'The form was invalid!'}
      end    
    end
  end

  def update    
    bs = current_user.bar_specials.find(params[:id])
    if bs.update_with_parse( bar_special_params )
      respond_to do |format|
        format.js { flash.now.notice = "Updated Special" }
      end
    else
      respond_to do |format|
        format.js   { flash.now.notice = bs.errors.full_messages.first}
      end
    end
  end

  def toggle_beerance
    @special = current_user.bar_specials.find(params[:id])
    if @special.toggle_activation
      respond_to do |format|
        format.js   { flash.now.notice = 'Updated Special' }
        format.html { redirect_to profile_path, notice: 'Updated Special' }
      end
    end
  end

  private

  def instantiate_new_special
    @bar_special = BarSpecial.new
  end

  def bar_special_params
    params.require(:bar_special).permit(:bar_id, :description, :sale_price, :beer_color, :beer_size)
  end
end
