class HomeController < ApplicationController
	before_filter :find_promoters
  before_filter :require_admin, except: %w{map index how_it_works privacy feedback send_feedback new_signup signup find_subscriber_email_id find_promoters}

  layout 'interior'
  
  def index
    @news_subscription = NewsSubscription.new
    render layout: 'marketing'
  end

  def map
    params[:distance] = params[:distance] ||= 10
    zip = params[:zip] || request.remote_ip.to_s
    geo = Geocoder.search(zip)
    lat = geo.first.data['geometry']['location']['lat']
    lng = geo.first.data['geometry']['location']['lng']
    @location = [lat, lng]
    
    @city = geo.first.data['address_components'][1]['long_name']        
    @specials = BarSpecials.near(:bar_location, @location, maxDistanceInMiles: params[:distance].to_i).all
    render layout: 'application'
  end

  def privacy
	  render layout: 'application'
  end

  def feedback
    @feedback = Feedback.new
  end

  def send_feedback
    feedback = Feedback.new params[:feedback]
    Notifier.feedback(feedback).deliver
    redirect_to root_path, notice: 'Thank you for your feedback!'
  end

  def signup    
    @news_subscription = NewsSubscription.new
    @promoters = find_promoters
  end

  def new_signup
    new_name = params[:other_promoter_name]    
    
    @news_subscription = NewsSubscription.new params[:news_subscription]
    @news_subscription.promoter_name = new_name unless new_name.blank?    
    
    if @news_subscription.save
      @news_subscription.subscribe_to_mailchimp
      redirect_to :back, notice: "Thank you for signing up!"
    else
      redirect_to :back, notice: "#{@news_subscription.errors.full_messages.first}"
    end
  end

  def find_promoters
    NewsSubscription.all.map(&:promoter_name).uniq.compact.sort
  end

  def find_subscriber_email_id(subscriber_type)
    case subscriber_type
    when "bar_owner"
      OWNERS_NEWS_LIST_ID
    when "bar_drinker"
      DRINKER_NEWS_LIST_ID
    end
  end
end
