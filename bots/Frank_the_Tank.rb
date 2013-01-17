require 'rrobots/robot.rb'

class Frank_the_Tank
   include Robot

  def tick events

   if events['robot_scanned'].empty? 
     turn_gun 8
   else    
     fire 1.5
     turn_gun -11
   end 
   
  @last_hit = time unless events['got_hit'].empty? 
	if @last_hit && time - @last_hit < 20
      say 'Merely a flesh wound!'
  	  accelerate 3
      turn -5
	elsif energy < 20
	say 'Oh, Poop!'
	end
	
  end
end
  

