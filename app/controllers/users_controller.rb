class UsersController < ApplicationController

  def timers
    @timers = current_user.timers.page(params[:page]).order("id desc")  
  end
end
