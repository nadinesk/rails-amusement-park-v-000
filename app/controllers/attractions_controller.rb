class AttractionsController <_ApplicationController

  def index
    @attractions = Attraction.all
  end

end
