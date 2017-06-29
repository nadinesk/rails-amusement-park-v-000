class User < ActiveRecord::Base
  # write associations here

  validates_presence_of :name
  validates_presence_of :nausea
  validates_presence_of :height
  validates_presence_of :tickets
  validates :password, presence: true, confirmation: true, length: { minimum: 8 }
  # validates_presence_of :admin ?

  has_many :rides
  has_many :attractions, through: :rides

  has_secure_password

  def mood
    if self.happiness && self.nausea
      if self.nausea > self.happiness
        mood = "sad"
      else
        mood = "happy"
      end
    end
  end

end
