module RestaurantHelper
  
  def convert_12hr_time(time_string)
    
    unless time_string[0] == "+"
      hours_string = "#{time_string[0]}#{time_string[1]}"
      minutes_string = "#{time_string[2]}#{time_string[3]}"
    else
      hours_string = "#{time_string[1]}#{time_string[2]}"
      minutes_string = "#{time_string[3]}#{time_string[4]}"      
    end
  
    hours_int = hours_string.to_i
    minutes_int = minutes_string.to_i
  
    if hours_int > 12 
      time = "#{(hours_int-12).to_s}:#{minutes_string} pm"
    else
      time = "#{hours_int.to_s}:#{minutes_string} am"
    end  
  end
  
end