module UsersHelper
  def expiration_date_format(expiration_date)
    days_left = (expiration_date-Date.today).to_i
    days_left = days_left > 0 ? "<span style='color: green'>#{pluralize(days_left, 'day')}</span>" : "<span style='color:red'>Expired!</span>"
    "#{expiration_date.strftime("%A, %b %d, %Y")} (#{days_left})".html_safe
  end

  def beer_color_image(beer_color_number)
    case beer_color_number
      when 1
        image_tag "beer_icon_02.jpg", style: 'height: 52px; width: 32px;'
      when 2
        image_tag "beer_icon_03.jpg", style: 'height: 52px; width: 32px;'
      when 3
        image_tag "beer_icon_04.jpg", style: 'height: 52px; width: 32px;'
      when 4
        image_tag "beer_icon_05.jpg", style: 'height: 52px; width: 32px;'
      else
        image_tag "beer_icon_05.jpg", style: 'height: 52px; width: 32px;'
    end
  end
end
