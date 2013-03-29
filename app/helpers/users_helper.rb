module UsersHelper
  def expiration_date_format(expiration_date)
    days_left = (expiration_date-Date.today).to_i
    days_left = days_left > 0 ? "<span style='color: green'>#{pluralize(days_left, 'day')}</span>" : "<span style='color:red'>Expired!</span>"
    "#{expiration_date.strftime("%A, %b %d, %Y")} (#{days_left})".html_safe
  end
end
