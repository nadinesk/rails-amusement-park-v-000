class RidesController < ApplicationController

	def new
		
		@ride = Ride.create(:user_id => params[:user_id], :attraction_id => params[:attraction_id])
		@message = @ride.take_ride		
		redirect_to user_path(params[:user_id], :message => @message)
	end

	private


end