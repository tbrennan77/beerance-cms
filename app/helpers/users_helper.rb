module UsersHelper
  def expiration_date_format(expiration_date)
    days_left = (expiration_date-Date.today).to_i
    days_left = days_left > 0 ? "<span style='color: green'>#{pluralize(days_left, 'day')}</span>" : "<span style='color:red'>Expired!</span>"
    "#{expiration_date.strftime("%A, %b %d, %Y")} (#{days_left})".html_safe
  end

  def beer_color_image(beer_color_number)
    case beer_color_number
      when 0
        image_tag "black.png", style: 'height: 52px; width: 32px; vertical-align: middle; margin-top: -12px; margin-right: 18px; margin-left: 8px;'
      when 1
        image_tag "red.png", style: 'height: 52px; width: 32px; vertical-align: middle; margin-top: -12px; margin-right: 18px; margin-left: 8px;'
      when 2
        image_tag "pale.png", style: 'height: 52px; width: 32px; vertical-align: middle; margin-top: -12px; margin-right: 18px; margin-left: 8px;'
      when 3
        image_tag "amber.png", style: 'height: 52px; width: 32px; vertical-align: middle; margin-top: -12px; margin-right: 18px; margin-left: 8px;'
    end
  end

  def has_a_bar?
    current_user.bars.count > 0
  end

  def my_bars(number)
    "My "+ pluralize(number, 'Bar').gsub(/[\d]/, '')
  end

  def current_subnav(path)
    case request.path_info
      when path
        'current'
      else
        ''
      end
  end
end
