require 'rrobots/robot'
require 'rrobots/battlefield'
require 'rrobots/explosion'
require 'rrobots/bullet'
require 'rrobots/robot_runner'
require 'rrobots/numeric'

class Gepetto
   include Robot

  def tick events
  	(dist = events['robot_scanned']).empty?
    if events['robot_scanned'].empty?
    	accelerate 8
    	turn 2
    	turn_gun 12
    else 
    	turn_gun -8
    	if (dist.first.first / 2).to_i <= 200
    		fire 1
    		say 'I\'m coming for YOU!'
      	else
    		fire 0.8
    		
    	end
    	accelerate -5
    	turn 0
	end
  
    	@last_hit = time unless events['got_hit'].empty? 
		if @last_hit && time - @last_hit < 1
      	accelerate(8)
      	turn 1
      	say 'Gepetto feel no good!'
    	end
	end
end
