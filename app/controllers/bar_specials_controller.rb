class BarSpecialsController < ApplicationController
  WRITABLE_ATTRIBUTES = %w{ bar_id special_description sale_price beer_color beer_size }

  before_filter :require_user
  before_filter :confirm_correct_user, except: %w{new}
  before_filter :confirm_active_subscription, only: %w{create}

  def new  
    @bar_special = BarSpecials.new    
  end  
    
  def create  
    params[:bar_specials].assert_valid_keys WRITABLE_ATTRIBUTES
    @bar_special = BarSpecials.new params[:bar_specials]
    if @bar_special.save
      get_specials
      respond_to do |f|
        f.html {redirect_to profile_path, :notice => "Added Special!"}
        f.js { flash.now.notice = "Added Special!"; @bar_special = BarSpecials.new}
      end
    else  
      render "new"  
    end  
  end

  def update    
    bs = BarSpecials.find params[:id]
    params[:bar_specials][:sale_price] = params[:bar_specials][:sale_price].to_f
    params[:bar_specials][:beer_size] = params[:bar_specials][:beer_size].to_i
    if bs.update_attributes params[:bar_specials]  
      get_specials
      respond_to do |format|
        format.js { 
          flash.now.notice = "Updated Special"
          @bar_special = BarSpecials.new
        }
        format.html
      end
    else
      respond_to do |format|
        format.js
        format.html
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

  def confirm_active_subscription
    if params[:action] == 'reactivate_special'
      bar = BarSpecials.find(params[:id]).bar
    else 
      bar = BarEntity.find(params[:bar_specials][:bar_id])
    end

    if request.xhr?
      script = <<-END_SCRIPT
        $('.alert-box.notice').remove();
        $('#ajax_bar').before('<div class="alert-box notice">Your subscription is not active!</div>');
        $('.alert-box.notice').hide().fadeIn('slow').delay(4000).fadeOut();
      END_SCRIPT

      if !bar.subscription.active?
        render js: script
      end        
    else
      redirect_to profile_path, notice: 'Your subscription is not active' unless bar.subscription.active?
    end
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
