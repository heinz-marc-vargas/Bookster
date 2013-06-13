class Review < ActiveRecord::Base
  belongs_to :branch
  belongs_to :customer    
  belongs_to :event

end
