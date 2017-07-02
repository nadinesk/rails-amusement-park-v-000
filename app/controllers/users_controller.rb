class UsersController < ApplicationController


	before_action :set_user, only: [:show, :edit, :update, :destroy]
	def new
		
		@user =  User.new		
	end

	def create		
	    @user = User.create(user_params)
	    
	    if @user.save

	    	session[:user_id] = @user.id
			redirect_to user_path(id: @user.id)			
	   	else	   	
	    	return redirect_to controller: 'users', action: 'new' 
		end
	end

	def show						
		
		@message = params[:message] if params[:message]
    	
	end


	private

	def set_user
		@user = User.find(params[:id])
	end


	def user_params
		params.require(:user).permit(:name, :password,  :nausea, :happiness, :tickets, :height, :admin)
	end

end
  