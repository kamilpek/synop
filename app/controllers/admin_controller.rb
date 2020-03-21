class AdminController < ApplicationController
  before_action :authenticate_user!

  def main
  end

  def users
    @users = User.all
    @users = @users.paginate(:page => params[:page], :per_page => 15)
  end
end
