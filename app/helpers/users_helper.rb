module UsersHelper
  def expiration_date_format(expiration_date)
    days_left = (expiration_date-Date.today).to_i
    days_left = days_left > 0 ? "<span style='color: green'>#{pluralize(days_left, 'day')}</span>" : "<span style='color:red'>Expired!</span>"
    "#{expiration_date.strftime("%A, %b %d, %Y")} (#{days_left})".html_safe
  end

  def beer_color_image(beer_color_number)
    case beer_color_number
      when 1
        image_tag "beer_icon_02.png", style: 'height: 52px; width: 32px;'
      when 2
        image_tag "beer_icon_03.png", style: 'height: 52px; width: 32px;'
      when 3
        image_tag "beer_icon_04.png", style: 'height: 52px; width: 32px;'
      when 4
        image_tag "beer_icon_05.png", style: 'height: 52px; width: 32px;'
      else
        image_tag "beer_icon_05.png", style: 'height: 52px; width: 32px;'
    end
  end

  def has_a_bar?
    if BarEntity.where(bar_owner_id: current_user.id).count == 0
      "active"
    end
  end
end
