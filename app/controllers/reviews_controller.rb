class ReviewsController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @review = Review.new
  end
  
  def create
    @review = Review.new(review_params)
    
    if @review.save
      render 'restaurants/view'
    else
      render new
    end

  end

  def destroy
  end
  
  private
  
  def review_params
    params.require(:review).permit(:title, :content)  
  end
  
end
