require 'rrobots/robot.rb'

class BorderPatrol
  include Robot
  
  def initialize 
    @north = 0
    @east = 1
    @south = 2
    @west = 3
  end
  
  def find_closest_border
    distances = {
      :dnorth => y,
      :dsouth => battlefield_height - y,
      :dwest => x,
      :deast => battlefield_width - x
    }
    direction = distances.min_by { |k, v| v }
    direction[0]
  end
  
  def tick events
    
    # say("I want to go #{find_closest_border}")
#    puts "Radar heading #{radar_heading}"
#    puts "Gun heading #{gun_heading}"
#    puts "Robot heading #{heading}"
    
    turn_gun 1
    fire 0.5
#    puts "Gun heat #{gun_heat}"
  end
end
