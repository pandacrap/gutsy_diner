module StaticMapHelper
 
def static_map_for(lat, lng, options = {})
params = {
:center => [lat, lng].join(","),
:zoom => 15,
:size => "300x300",
:markers => [lat, lng].join(","),
:sensor => true
}.merge(options)
 
query_string = params.map{|k,v| "#{k}=#{v}"}.join("&")
image_tag "http://maps.googleapis.com/maps/api/staticmap?#{query_string}"
end
 
end