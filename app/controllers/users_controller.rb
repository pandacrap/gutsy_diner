class UsersController < ApplicationController
  def show
    @reviews = User.find_by(id: params[:id]).reviews.all
  end
end
