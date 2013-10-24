module ApplicationHelper
  def resource_name
    :user
  end
 
  def resource
    @resource ||= User.new
  end
 
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def meta_tags
    MetaTag.count > 0 ? MetaTag.first.text.html_safe : '<meta />'.html_safe
  end

  def title(page_title)
    content_for :title, page_title.to_s
  end

  def is_current?(action)
    "current" if params[:action] == action
  end

  def are_current?(actions)
   "current" if actions.include? params[:action]
  end

  def format_plan(bar)
    return "N/A" if bar.user.admin? || bar.user.gary?
    bar.active_subscription? ? bar.subscription_plan.friendly_name : 'No Plan'    
  end

  def format_status(bar)
    return "N/A" if bar.user.admin? || bar.user.gary?
    bar.active_subscription? ? bar.subscription.status.capitalize : 'Not Active'
  end
  
  def beer_color_image(beer_color_number)
    image_name = case beer_color_number
      when 0
        "black.png"
      when 1
        "red.png"
      when 2
        "pale.png"
      when 3
        "amber.png"
    end
    image_tag image_name
  end

  def states
    @states = [
         [ "Alabama", "AL" ],
         [ "Alaska", "AK" ],
         [ "Arizona", "AZ" ],
         [ "Arkansas", "AR" ],
         [ "California", "CA" ],
         [ "Colorado", "CO" ],
         [ "Connecticut", "CT" ],
         [ "Delaware", "DE" ],
         [ "Florida", "FL" ],
         [ "Georgia", "GA" ],
         [ "Hawaii", "HI" ],
         [ "Idaho", "ID" ],
         [ "Illinois", "IL" ],
         [ "Indiana", "IN" ],
         [ "Iowa", "IA" ],
         [ "Kansas", "KS" ],
         [ "Kentucky", "KY" ],
         [ "Louisiana", "LA" ],
         [ "Maine", "ME" ],
         [ "Maryland", "MD" ],
         [ "Massachusetts", "MA" ],
         [ "Michigan", "MI" ],
         [ "Minnesota", "MN" ],
         [ "Mississippi", "MS" ],
         [ "Missouri", "MO" ],
         [ "Montana", "MT" ],
         [ "Nebraska", "NE" ],
         [ "Nevada", "NV" ],
         [ "New Hampshire", "NH" ],
         [ "New Jersey", "NJ" ],
         [ "New Mexico", "NM" ],
         [ "New York", "NY" ],
         [ "North Carolina", "NC" ],
         [ "North Dakota", "ND" ],
         [ "Ohio", "OH" ],
         [ "Oklahoma", "OK" ],
         [ "Oregon", "OR" ],
         [ "Pennsylvania", "PA" ],
         [ "Rhode Island", "RI" ],
         [ "South Carolina", "SC" ],
         [ "South Dakota", "SD" ],
         [ "Tennessee", "TN" ],
         [ "Texas", "TX" ],
         [ "Utah", "UT" ],
         [ "Vermont", "VT" ],
         [ "Virginia", "VA" ],
         [ "Washington", "WA" ],
         [ "West Virginia", "WV" ],
         [ "Wisconsin", "WI" ],
         [ "Wyoming", "WY" ]
       ]
  end

  def times 
   @times = [
      ["Closed"],
      ["12:00 AM"],
      ["12:30 AM"],
      ["1:00 AM"],
      ["1:30 AM"],
      ["2:00 AM"],
      ["2:30 AM"],
      ["3:00 AM"],
      ["3:30 AM"],
      ["4:00 AM"],
      ["4:30 AM"],
      ["5:00 AM"],
      ["5:30 AM"],
      ["6:00 AM"],
      ["6:30 AM"],
      ["7:00 AM"],
      ["7:30 AM"],
      ["8:00 AM"],
      ["8:30 AM"],
      ["9:00 AM"],
      ["9:30 AM"],
      ["10:00 AM"],
      ["10:30 AM"],
      ["11:00 AM"],
      ["11:30 AM"],
      ["12:00 PM"],
      ["12:30 PM"],
      ["1:00 PM"],
      ["1:30 PM"],
      ["2:00 PM"],
      ["2:30 PM"],
      ["3:00 PM"],
      ["3:30 PM"],
      ["4:00 PM"],
      ["4:30 PM"],
      ["5:00 PM"],
      ["5:30 PM"],
      ["6:00 PM"],
      ["6:30 PM"],
      ["7:00 PM"],
      ["7:30 PM"],
      ["8:00 PM"],
      ["8:30 PM"],
      ["9:00 PM"],
      ["9:30 PM"],
      ["10:00 PM"],
      ["10:30 PM"],
      ["11:00 PM"],
      ["11:30 PM"]
   ]
  end
end
