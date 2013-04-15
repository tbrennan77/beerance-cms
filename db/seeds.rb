# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

SubscriptionPlan.create(amount: 3000,  friendly_name: 'Plan 1', image: 'red.png', length_in_months: 3, name: '3_months')
SubscriptionPlan.create(amount: 5700,  friendly_name: 'Plan 2', image: 'amber.png', length_in_months: 6, name: '6_months')
SubscriptionPlan.create(amount: 10200, friendly_name: 'Plan 3', image: 'black.png', length_in_months: 12, name: '12_months')