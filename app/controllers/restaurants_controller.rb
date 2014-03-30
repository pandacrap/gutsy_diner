class RestaurantsController < ApplicationController
  require 'foursquare2'
  require 'date'
  require 'geocoder'
  require 'gmaps4rails'
  require 'twitter'
  
  def index
    @restaurant = Restaurant.all
  end
  
  def show    
    client = Foursquare2::Client.new(:client_id => 'IGHYS4WU2EMECJYBR5E3YLPVOEKWLVA4JUQFJHG4Q1A3IGOF', :client_secret => '0F5SDZRAMTBS2V3RP0ECJSE2AVIGDXC5FA42XDDG341EYBFB', :api_version => '20120505')
    @ref = Restaurant.find_by(:id => params[:id]).ref
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
  
  def search 
    client = Foursquare2::Client.new(:client_id => 'IGHYS4WU2EMECJYBR5E3YLPVOEKWLVA4JUQFJHG4Q1A3IGOF', :client_secret => '0F5SDZRAMTBS2V3RP0ECJSE2AVIGDXC5FA42XDDG341EYBFB', :api_version => '20120505')

    query = params[:query]        
    location = Geocoder.search(params[:location])
    @lat = location[0].data["geometry"]["location"]["lat"]
    @lng = location[0].data["geometry"]["location"]["lng"]
    formatted_address = location.first.data["geometry"]["formatted_address"]


    venues = client.search_venues(:ll => "#{@lat},#{@lng}", :query => query, :categoryId => "4d4b7105d754a06374d81259,4d4b7105d754a06376d81259", :intent => "checkin", :radius => "3000")
    @results = venues["venues"]
    
    if @results.nil?
      redirect_to root_path
    else
      @hash = Gmaps4rails.build_markers(@results) do |result, marker|
        marker.lat result["location"]["lat"]
        marker.lng result["location"]["lng"]
        marker.infowindow "<div style='width: 150px; height: 100px;'>#{result['name']}<br>#{result['location']['address']}<br>#{result['location']['city']} #{result['location']['state']}<br><a href='/view?ref=#{result['id']}'>Show more!</a></div>"
      end
    end
  end  

  def view        
    @ref = params[:ref]  
    @restaurant = Restaurant.find_by(ref: @ref)
    
    unless @restaurant.nil?
      redirect_to restaurant_path(@restaurant)
    end
    
    client = Foursquare2::Client.new(:client_id => 'IGHYS4WU2EMECJYBR5E3YLPVOEKWLVA4JUQFJHG4Q1A3IGOF', :client_secret => '0F5SDZRAMTBS2V3RP0ECJSE2AVIGDXC5FA42XDDG341EYBFB', :api_version => '20120505')      
    @results = client.venue(@ref)
    @name = @results["name"]
    @hours = client.venue_hours(@ref)
    @restaurant = Restaurant.new
    @restaurant.reviews.build
    @review_items = []
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
