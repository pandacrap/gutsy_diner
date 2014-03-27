class RestaurantsController < ApplicationController
  require 'foursquare2'
  require 'date'
  require 'geocoder'
  require 'gmaps4rails'
  
  def index
    @restaurant = Restaurant.all
  end
  
  def show    
    client = Foursquare2::Client.new(:client_id => 'IGHYS4WU2EMECJYBR5E3YLPVOEKWLVA4JUQFJHG4Q1A3IGOF', :client_secret => '0F5SDZRAMTBS2V3RP0ECJSE2AVIGDXC5FA42XDDG341EYBFB', :api_version => '20120505')
    @ref = Restaurant.find_by(:id => params[:id]).ref
    #@ref = '4d65ca18cfd48eec7c03e697'
    venues = client.venue(@ref)
    @results = venues



    @name = @results["name"]
    @hours = client.venue_hours(@ref)
    
    
    @restaurant = Restaurant.new
    @restaurant.reviews.build
    
    @review_list = Restaurant.find_by(ref: @ref)

    if @review_list.nil?
      @review_items = []
    else      
      @review_items = @review_list.reviews.all
    end
  end  

  def view    
    client = Foursquare2::Client.new(:client_id => 'IGHYS4WU2EMECJYBR5E3YLPVOEKWLVA4JUQFJHG4Q1A3IGOF', :client_secret => '0F5SDZRAMTBS2V3RP0ECJSE2AVIGDXC5FA42XDDG341EYBFB', :api_version => '20120505')
    
    @ref = params[:ref]  
    
    if @ref.nil?
    
      location = Geocoder.search(params[:location])
    
  
        @lat = location[0].data["geometry"]["location"]["lat"]
        @lng = location[0].data["geometry"]["location"]["lng"]
        formatted_address = location.first.data["geometry"]["formatted_address"]

    
      query = params[:query]

      #@ref = '4d65ca18cfd48eec7c03e697'
      venues = client.search_venues(:ll => "#{@lat},#{@lng}", :query => query, :categoryId => "4d4b7105d754a06374d81259,4d4b7105d754a06376d81259")
      
      @results = venues["venues"]
      
      if @results.nil?
        redirect_to root_path
      end
      
      if @results.count > 1
        render :partial => 'shared/multiple_results'
      end

      @results = venues["venues"].first
    
    else
      venues = client.venue(@ref)
      @results = venues
    end

    #@results = client.venue(@ref)
    #@hours = client.venue_hours(@ref)
    @ref = @results["id"]    
    @name = @results["name"]
    @hours = client.venue_hours(@ref)
    
    
    @restaurant = Restaurant.new
    @restaurant.reviews.build
    @review_list = Restaurant.find_by(ref: @ref)

    if @review_list.nil?
      @review_items = []
    else      
      @review_items = @review_list.reviews.all
    end
  end
  
  def new
    @restaurant =  Restaurant.new
    @review = @restaurant.reviews.build
    @review_list = Restaurant.find_by(ref: @ref).reviews.all    

    if @review_list.nil?
      @review_items = []
    else      
      @review_items = Review.all
    end
  end
  
  def create
    @restaurant = Restaurant.find_by(ref: restaurant_params[:ref]) 

    if @restaurant.nil?
      @restaurant = Restaurant.new(restaurant_params) 
      @restaurant.save   
    else
      @review = @restaurant.reviews.new(restaurant_params[:reviews_attributes]["0"])      
      @review.save
    end
    
    redirect_to @restaurant
  end
  
  private
    
  def restaurant_params
    params.require(:restaurant).permit(:ref, :name, 
      :reviews_attributes => [:id, :title, :content])  
  end    
end
