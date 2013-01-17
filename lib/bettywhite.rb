require_relative 'rrobots/robot.rb'

class Bettywhite
	include Robot
	
	def initialize
	 @rapid_fire = 1 
	 @last_seen = 1
	 @turn_speed = 3
	 #@direction = -1
	 #@height = battlefield_height 
	 #@width = battlefield_width 
	end
	
	def on_wall?
           @battlefield_width - x <= size*3 or @battlefield_height - y <= size*3
         end
	
	def tick events
	
		if time - @last_seen > 100
			@turn_speed *= 1
			@last_seen = time
		end

		turn @turn_speed
		
		if( @rapid_fire > 0 )
			fire 0.86
			turn_gun -(@turn_speed / @turn_speed) *2
			@rapid_fire = @rapid_fire - 1
		else
			turn_gun @turn_speed * 1
			stop 
		end

		if( !events['robot_scanned'].empty? )
			@turn_speed *= -1
			@last_seen = time
			say 'heh heh!'
			@rapid_fire = 20
		end
		
		if on_wall? 
                   fire 0.86
                   say 'gottcha'
			turn_gun -(@turn_speed / @turn_speed) *2
			@rapid_fire = @rapid_fire - 1
			accelerate(1)
                 
		end
		@last_hit = time unless events['got_hit'].empty?
		if @last_hit && time - @last_hit < 20
			accelerate(-1)
		else
			accelerate 1
		end
	end
end