class MetaTag < ActiveRecord::Base
  validates_presence_of :text
end
