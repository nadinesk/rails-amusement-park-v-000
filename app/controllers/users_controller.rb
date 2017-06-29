class UsersController < ApplicationController

  def new

  end

  def create
    @user = User.create(user_params)
    return redirect_to controller: 'users', action: 'new' unless @user.save
    session[:user_id] = @user.id
    redirect_to user_path(id: @user.id)
  end

  def show
    unless current_user.admin?
       unless @user == current_user
         redirect_to :back, :alert => "Access denied."
       end
     end
  end

  private

    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation)
    end
end
