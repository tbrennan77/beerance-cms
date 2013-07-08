class Feedback
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  attr_accessor :name, :email, :phone, :category, :comment
  
  def persisted?
    false
  end

  def initialize(params={})
    @name     = params[:name]
    @email    = params[:email]
    @phone    = params[:phone]
    @category = params[:category]
    @comment  = params[:comment]
  end
end