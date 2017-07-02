class Attraction < ActiveRecord::Base

	has_many :rides
  	has_many :users, through: :rides

  	#validates :nausea_rating, :min_height, :tickets, presence: true

end
