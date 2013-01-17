require 'rrobots/robot.rb'

class Twitch
   include Robot

  def initialize 
    @passage_time = 0
  end
  
            
  def tick events   
      
   @passage_time = @passage_time + 1
   if @passage_time < 100 
     accelerate 4
    # turn 1
   elsif @passage_time > 200
     @passage_time = 0
   else
     accelerate -4
    # turn -1
   end
   
   #if @passage_time == 0
   #  turn 2
   #elsif turn 0
   #else @passage_time == 150
   #  turn -2
   #end
     
   if time == 0 
     @passage_time = 0
   end
   
   if !events['got_hit'].empty? && energy.between?(1,40)
     say "That\'s starting to HURT"
   end
     
   if events['robot_scanned'].empty?  
     turn_gun 12
   else                               
     fire 1.5
     turn_gun -8
   end 
   
  end
end


