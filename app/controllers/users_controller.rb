class UsersController < ApplicationController
  def show
    @reviews = current_user.reviews.all
  end
end
