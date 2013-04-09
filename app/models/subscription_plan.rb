class SubscriptionPlan < ParseResource::Base
  fields :name, :amount, :friendly_name, :image, :length_in_months

  def cost_per_month
    ((amount/100).to_f / length_in_months).to_f
  end
end