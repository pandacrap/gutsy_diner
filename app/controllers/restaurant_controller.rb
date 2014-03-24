class RestaurantController < ApplicationController
  require 'foursquare2'
  require 'date'

  def view    
    @client = Foursquare2::Client.new(:client_id => 'IGHYS4WU2EMECJYBR5E3YLPVOEKWLVA4JUQFJHG4Q1A3IGOF', :client_secret => '0F5SDZRAMTBS2V3RP0ECJSE2AVIGDXC5FA42XDDG341EYBFB', :api_version => '20120505')
    @results = @client.venue('4d65ca18cfd48eec7c03e697')
    @hours = @client.venue_hours('4d65ca18cfd48eec7c03e697')
    
    @restaurant = Restaurant.exists?(id:1)
    
    
    #@reviews = @restaurant.reviews.all
  end
end
