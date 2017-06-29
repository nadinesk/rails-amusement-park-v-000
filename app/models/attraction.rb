class Attraction < ActiveRecord::Base
  # write associations here

  has_many :rides
  has_many :users, through: :rides


  validates_presence_of :name
  validates_presence_of :min_height
  validates_presence_of :nausea_rating
  validates_presence_of :happiness_rating
  validates_presence_of :tickets

  
end
