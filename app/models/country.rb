class Country < ActiveRecord::Base
  has_many :branches
  has_many :users
end
