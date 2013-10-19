class Feedback < ActiveRecord::Base
  belongs_to :user
  validates :category,
    inclusion: { 
      in: %w{Design Error Suggestion Request Other}, 
      message: 'must be selected'
    }
    
  validates_presence_of :comment

  default_scope { order('created_at ASC') }
end
