module StaticMapHelper
 
def static_map_for(lat, lng, options = {})
params = {
:center => [lat, lng].join(","),
:zoom => 16,
:size => "300x300",
:markers => [lat, lng].join(","),
:sensor => true
}.merge(options)
 
query_string = params.map{|k,v| "#{k}=#{v}"}.join("&")
image_tag "http://maps.googleapis.com/maps/api/staticmap?#{query_string}&style=feature%3Awater%7Celement%3Aall%7Cvisibility%3Aon%7Ccolor%3A0xb5cbe4%7C&style=feature%3Alandscape%7Celement%3Aall%7Ccolor%3A0xefefef%7C&style=feature%3Aroad.highway%7Celement%3Ageometry%7Ccolor%3A0x83a5b0%7C&style=feature%3Aroad.arterial%7Celement%3Ageometry%7Ccolor%3A0xbdcdd3%7C&style=feature%3Aroad.local%7Celement%3Ageometry%7Ccolor%3A0xffffff%7C&style=feature%3Apoi.park%7Celement%3Ageometry%7Ccolor%3A0xe3eed3%7C&style=feature%3Aadministrative%7Celement%3Aall%7Cvisibility%3Aon%7Clightness%3A33%7C&style=&style=feature%3Apoi.park%7Celement%3Alabels%7Cvisibility%3Aon%7Clightness%3A20%7C&style=&style=feature%3Aroad%7Celement%3Aall%7Clightness%3A20%7C"
end
 
end