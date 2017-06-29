class Ride < ActiveRecord::Base
  # write associations here
  validates_presence_of :user_id
  validates_presence_of :attraction_id
  belongs_to :attraction
  belongs_to :user


  def take_ride
    if (self.user.height < self.attraction.min_height) && (self.user.tickets < self.attraction.tickets)
      "Sorry. You do not have enough tickets to ride the #{self.attraction.name}. You are not tall enough to ride the #{self.attraction.name}."
    elsif (self.user.tickets < self.attraction.tickets) && !(self.user.height < self.attraction.min_height)
        "Sorry. You do not have enough tickets to ride the #{self.attraction.name}."
    elsif (self.user.height < self.attraction.min-height) && !(self.user.tickets < self.attraction.tickets)
          "Sorry. You are not tall enough to ride the #{self.attraction.name}"
    else
      self.user.tickets = self.attraction.tickets - self.user.tickets
      self.user.happiness += self.attraction.happiness_rating
      self.user.nausea += self.attraction.nausea_rating
    end
  end


end
