class AttractionsController < ApplicationController


	def index		
		@attractions = Attraction.all		
	end

	def new
		@attraction = Attraction.new
	end

	def show		
		@attraction =  Attraction.find(params[:id])		

	end

	def create
		@attraction = Attraction.create(attraction_params)
			if @attraction.save
				redirect_to attraction_path(id: @attraction.id)			
		   	else
		    	return redirect_to controller: 'attractions', action: 'new' 
			end
	end

	def edit
		@attraction = Attraction.find_by(params[:id])
	end

	

	private

	def attraction_params
		params.require(:attraction).permit(:name, :tickets,  :nausea_rating, :happiness_rating, :min_height)
	end
end




