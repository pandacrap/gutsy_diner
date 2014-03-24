class StaticPagesController < ApplicationController
  require 'twitter'
  require 'foursquare2'
  require 'geocoder'
  
  def search
    @query_param = params[:q]
    @location_param = params[:l]
    
    @yclient = Yelp::Client.new
    
    @lresults = Geocoder.search(@location_param)
    
    lat = @lresults[0].geometry["location"]["lat"]
    lng = @lresults[0].geometry["location"]["lng"]
    
    location = "#{lat},#{lng}"


    @client = Foursquare2::Client.new(:client_id => 'IGHYS4WU2EMECJYBR5E3YLPVOEKWLVA4JUQFJHG4Q1A3IGOF', :client_secret => '0F5SDZRAMTBS2V3RP0ECJSE2AVIGDXC5FA42XDDG341EYBFB', :api_version => '20120505')
    @fresults = @client.search_venues(:ll => location, :query => @query_param)
    
    id = @fresults["venues"][0].id
    @twitter = @client.venue(id).contact.twitter
    
    @tclient = Twitter::REST::Client.new do |config|
      config.consumer_key        = "xBV33WlwEMWcBOhAwXA"
      config.consumer_secret     = "nwAIZsIVoboSFR1m3HpECG6KHiCHF52bPmhYFjHA"
      config.access_token        = "2339889157-udu1p9jeRY516MwqYlzNuDSKcrA1eDJGK38PYh9"
      config.access_token_secret = "PpwOUvXobiVywL2BkijBuMwSgJ676MqzegVn5r8B2hceH"
    end

    @tweets1 = nil
    
    unless @twitter.nil? 
      criteria = "from:#{@twitter} -RT AND #glutenfree OR #gf"
      @tweets1 = @tclient.search(criteria).collect 
    end
    
    render 'static_pages/home'
  end
  
  def home
    @query = "wurst"
    @location = "calgary"


    @client = Foursquare2::Client.new(:client_id => 'IGHYS4WU2EMECJYBR5E3YLPVOEKWLVA4JUQFJHG4Q1A3IGOF', :client_secret => '0F5SDZRAMTBS2V3RP0ECJSE2AVIGDXC5FA42XDDG341EYBFB', :api_version => '20120505')
    @fresults = @client.search_venues(:near => 'calgary', :query => @query)
    
    id = @fresults.venues[0].id
    @twitter = @client.venue(id).contact.twitter
    
    @tclient = Twitter::REST::Client.new do |config|
      config.consumer_key        = "xBV33WlwEMWcBOhAwXA"
      config.consumer_secret     = "nwAIZsIVoboSFR1m3HpECG6KHiCHF52bPmhYFjHA"
      config.access_token        = "2339889157-udu1p9jeRY516MwqYlzNuDSKcrA1eDJGK38PYh9"
      config.access_token_secret = "PpwOUvXobiVywL2BkijBuMwSgJ676MqzegVn5r8B2hceH"
    end
    
    @tweets1 = nil
    
    
    unless @twitter.nil? 
      criteria = "from:#{@twitter} -RT AND #glutenfree OR #gf"
      @tweets1 = @tclient.search(criteria).collect 
    end
    
    puts(@tweets1)
  end
end
