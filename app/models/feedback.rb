class Feedback
  include ActiveModel::Validations
  include ActiveModel::Conversion

  attr_accessor         :name, :email, :phone, :category, :comment
  validates_presence_of :name, :email, :phone, :category

  def initialize(attributes={})
    attributes.each do |name, value|
      send("#{name}=", value)
    end    
  end

  def persisted?
    false
  end
end
