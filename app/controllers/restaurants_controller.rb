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
    
    #retrieve info about restaurant
    @ref = Restaurant.find_by(:id => params[:id]).ref
    @results = client.venue(@ref)
    @name = @results["name"]
    @price = @results["attributes"]["groups"][0]["summary"]
    @hours = client.venue_hours(@ref)
  
    #build fields for new review  
    @restaurant = Restaurant.new
    @restaurant.reviews.build
    
    #find existing reviews
    @review_list = Restaurant.find_by(ref: @ref)

    #could have >= 0 reviews
    if @review_list.nil?
      @review_items = []
    else      
      @review_items = @review_list.reviews.all
    end
  end  
  
  def results
    
  end
    
  
  def search 
    client = Foursquare2::Client.new(:client_id => 'IGHYS4WU2EMECJYBR5E3YLPVOEKWLVA4JUQFJHG4Q1A3IGOF', :client_secret => '0F5SDZRAMTBS2V3RP0ECJSE2AVIGDXC5FA42XDDG341EYBFB', :api_version => '20120505')

    #retrieve lat and lng
    @query = params[:query]        
    @location = Geocoder.search(params[:location])
    
    #if location.length > 0, then partial match
    if @location.empty? or @location.length > 1 and params[:commit] == "Search"
      #list all potential addresses and let user pick
    
      render 'results'
    else
    
      @lat = @location.first.data["geometry"]["location"]["lat"]
      @lng = @location.first.data["geometry"]["location"]["lng"]
  
      venues = client.search_venues(:ll => "#{@lat},#{@lng}", :query => @query, :categoryId => "4d4b7105d754a06374d81259,4d4b7105d754a06376d81259", :intent => "checkin", :radius => "3000")
      @results = venues["venues"]
      #@price = @results["attributes"]["groups"][0]["summary"]
    
      #if results.length = 0, then no entries
    
      if @results.nil?
        redirect_to root_path
      else
        #defaults to 0,0 is no markers
        @hash = Gmaps4rails.build_markers(@results) do |result, marker|
          marker.lat result["location"]["lat"]
          marker.lng result["location"]["lng"]
          marker.infowindow "<div style='width: 150px; height: 100px;'>#{result['name']}<br>#{result['location']['address']}<br>#{result['location']['city']} #{result['location']['state']}<br><a href='/view?ref=#{result['id']}'>More info</a></div>"
        end
      end
    end
  end  

  def view      
    #find restaurant by ref parameter  
    @ref = params[:ref]  
    @restaurant = Restaurant.find_by(ref: @ref)
    
    #redirect to restaurant#show with full path
    unless @restaurant.nil?
      redirect_to restaurant_path(@restaurant)
    end
    
    client = Foursquare2::Client.new(:client_id => 'IGHYS4WU2EMECJYBR5E3YLPVOEKWLVA4JUQFJHG4Q1A3IGOF', :client_secret => '0F5SDZRAMTBS2V3RP0ECJSE2AVIGDXC5FA42XDDG341EYBFB', :api_version => '20120505')      
    
    #retrieve info about restaurant
    @results = client.venue(@ref)
    @name = @results["name"]
    @price = @results["attributes"]["groups"][0]["summary"]
    @hours = client.venue_hours(@ref)
    
    #find existing reviews
    @restaurant = Restaurant.new
    @restaurant.reviews.build
    @review_items = [] #equals nil since not redirected to show action
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
    @restaurant = Restaurant.find_by(ref: restaurant_params[:ref]) #check if restaurant exists

    if @restaurant.nil?
      @restaurant = Restaurant.new(restaurant_params) 
      @restaurant.save #save new restaurant and review
    else
      @review = @restaurant.reviews.new(restaurant_params[:reviews_attributes]["0"])
      @review.save #save review only
    end
    
    redirect_to @restaurant
  end
  
  private
    
  def restaurant_params
    params.require(:restaurant).permit(:ref, :name, 
      :reviews_attributes => [:id, :title, :content])  
  end    
end
