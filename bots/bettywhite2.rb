require 'rrobots/robot.rb'

class Bettywhite2
	include Robot
	def tick events
		
         #events.each do |event|
	 #puts event
         #end
		@rapid_fire = 0 if @rapid_fire.nil?
		@last_seen = 0 if @last_seen.nil?
		@turn_speed  = 3 if @turn_speed.nil?

		if time - @last_seen > 100
			@turn_speed *= -1
			@last_seen = time
		end

		turn @turn_speed

		if( @rapid_fire > 0 )
			fire 0.86
			turn_gun -(@turn_speed / @turn_speed) *2
			@rapid_fire = @rapid_fire - 1
		else
			turn_gun @turn_speed * 2.75
			end
			
		if( !events['robot_scanned'].empty? )
			@turn_speed *= -1
			@last_seen = time
			@rapid_fire = 
turn_radar 15 if time == 0
    turn_gun 5 if time == 0
    fire 1
    accelerate (5)
    turn -2
    fire 0.1
    turn 3


		end
		@last_hit = time unless events['got_hit'].empty?
		if @last_hit && time - @last_hit < 20
			accelerate(-1)
		else
			accelerate 1
		end
	end
end