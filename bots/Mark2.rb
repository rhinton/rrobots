require 'rrobots/robot.rb'

class Mark2
   	include Robot
   	
   	@smack       #array
   	@new_heading 
   	
   	@radar_headings #array
   	
   	@current_radar_heading_index 
   	
   	@hit_east_wall
   	@hit_west_wall
   	@hit_north_wall
   	@hit_south_wall

	def initialize
		@smack = []
		@smack.push "I am the ERADICATOR !!!"
		@smack.push "I will ERADICATE YOU !!!"
		@smack.push "Did your mommy dress you ???"
		@smack.push "I'm just getting started!"
		@smack.push "I love the smell of napalm in the morning"
		@smack.push "Turn around bright eyes ... BAM!"
		
   		@hit_east_wall  = false
   		@hit_west_wall  = false
   		@hit_north_wall = false
   		@hit_south_wall = false
   		
   		@new_heading = 0
   		
     	@radar_headings = [  0,  10,  20,  30,  40,  50,  60,  70,  80,  90,
   	                       100, 110, 120, 130, 140, 150, 160, 170, 180, 190,
   	                       200, 210, 220, 230, 240, 250, 260, 270, 280, 290,
   	                       300, 310, 320, 330, 340, 350 ]   		
   		
   		@current_radar_heading_index = 0
	end
	
  	def tick events
  		output_events events
  		taunt
  		adjust_heading_tank events
  		fire_gun events
  		adjust_heading_radar events
		goto_speed 1
  	end
  	
  	def output_events events
  		if events.size > 0
			puts '----------------------------------  EVENTS'
  			puts "Mark's events:"
  			puts events
			puts '----------------------------------'
  		end
  	end
  	
  	def fire_gun events
  		if events['robot_scanned'].empty? 
  		else
  			fire 3.0 
  		end
  	end
  	
  	def adjust_heading_tank events
  		#decide where to go and set new heading
  		hit_wall? 		
  		#head towards new heading
  		if events['robot_scanned'].empty?
  		else
  			@new_heading = radar_heading
  		end
  		
  		turn_to_new_heading_tank @new_heading

  	end
  		
  	def adjust_heading_radar events
  	
  		turn_to_new_heading_radar @radar_headings[@current_radar_heading_index] 
  		#increment radar heading index	
  		increment_radar_heading_index
  	end
  	
  	def increment_radar_heading_index
		puts '----------------------------------'
  		if @current_radar_heading_index == ((@radar_headings.length) -1)
  			puts 'resetting current radar heading index'
  			@current_radar_heading_index = 0
  		else
  			puts 'incrementing current radar heading index'
  			@current_radar_heading_index += 1
  		end
		puts ' radar heading array length = ' + @radar_headings.length.to_s
		puts 'current radar heading index = ' + @current_radar_heading_index.to_s
		puts '----------------------------------'
  		
  	end


	def turn_to_new_heading_radar new_heading
		puts '----------------------------------'
		puts 'current heading radar = ' + @radar_headings[@current_radar_heading_index].to_s
		puts 'actual  heading radar = ' + radar_heading.to_s
		puts 'new     heading radar = ' + new_heading.to_s
		adjust_heading = calculate_degrees_to_new_heading( new_heading, radar_heading )
		puts 'adjust  heading radar by ' + adjust_heading.to_s + ' degrees'
		puts '----------------------------------'
		turn_radar(adjust_heading)
	end
	

	def goto_speed speed
		if @speed < speed
			accelerate(1)
		end
	end

	def taunt
		if time % 300 == 0 
			if @smack.size > 0
				say(@smack.pop)
			end
		end
	end  
	
	def turn_to_new_heading_tank new_heading
		puts '----------------------------------'
		puts 'new heading tank = ' + new_heading.to_s
		adjust_heading = calculate_degrees_to_new_heading(new_heading, heading)
		puts 'adjust heading by ' + adjust_heading.to_s + ' degrees'
		puts '----------------------------------'
		turn(adjust_heading)
	end

	
	def calculate_degrees_to_new_heading new_heading, cur_heading
		
		degrees_to_new_heading = new_heading - cur_heading
		puts "calculate_degrees_to_new_heading = \n"         +
		     "        current heading = " + cur_heading.to_s     + "\n" +
		     "            new heading = " + new_heading.to_s + "\n" +
		     " degrees to new heading = " + degrees_to_new_heading.to_s
		calculate_shortest_turn degrees_to_new_heading
	end
	
	def calculate_shortest_turn correction
	
		puts '----------------------------------'
		if correction.abs > 180
			#new_correction = correction.abs - 180
			new_correction = 360 - correction.abs
			puts 'new correction = ' + new_correction.to_s
			if correction < 0 
				new_correction *= -1
			end
			puts ' .... new correction = ' + new_correction.to_s
			new_correction
		else
			correction
		end
	end

  	def hit_wall?
  	
		puts '----------------------------------'
  		puts 'hit wall?' 
  		puts 'size = ' + size.to_s
  		puts '   w = ' + battlefield_width.to_s
  		puts '   x = ' + x.to_s
  		puts '   h = ' + battlefield_height.to_s
  		puts '   y = ' + y.to_s
  		
  		
  		#west wall
  		if x <= size
  			 say 'hit west wall'
  			puts 'hit west wall'
  			@hit_west_wall = true
  		else 
  			@hit_west_wall = false
  		end
  		
  		#east wall
  		if x + size >= battlefield_width
  			 say 'hit east wall'
  			puts 'hit east wall'
  			@hit_east_wall = true
  		else 
  			@hit_east_wall = false
  		end
  		
  		#south wall
  		if y + size >= battlefield_height
  			 say 'hit south wall'
  			puts 'hit south wall'
  			@hit_south_wall = true
  		else
  			@hit_south_wall = false
  		end
  		
  		#north wall
  		if y <= size
  			 say 'hit north wall'
  			puts 'hit north wall'
  			@hit_north_wall = true
  		else
  			@hit_north_wall = false
  		end
		puts '----------------------------------'
  	end

	
	def turn_west?
		#depends on angle of heading to wall hit 
	end
	
	def turn_north?
		#depends on angle of heading to wall hit
	end

end



=begin
rrobots markp$ ruby bin/rrobots lib/Mark.rb lib/Mark.rb

  battlefield_height  #the height of the battlefield
  battlefield_width   #the width of the battlefield
  energy              #your remaining energy (if this drops below 0 you are dead)
  gun_heading         #the heading of your gun, 0 pointing east, 90 pointing 
                      #north, 180 pointing west, 270 pointing south
  gun_heat            #your gun heat, if this is above 0 you can't shoot
  heading             #your robots heading, 0 pointing east, 90 pointing north,
                      #180 pointing west, 270 pointing south
  size                #your robots radius, if x <= size you hit the left wall
  radar_heading       #the heading of your radar, 0 pointing east, 
                      #90 pointing north, 180 pointing west, 270 pointing south
  time                #ticks since match start
  speed               #your speed (-8/8)
  x                   #your x coordinate, 0...battlefield_width
  y                   #your y coordinate, 0...battlefield_height
  accelerate(param)   #accelerate (max speed is 8, max accelerate is 1/-1, 
                      #negativ speed means moving backwards)
  stop                #accelerates negativ if moving forward (and vice versa), 
                      #may take 8 ticks to stop (and you have to call it every tick)
  fire(power)         #fires a bullet in the direction of your gun, 
                      #power is 0.1 - 3, this power will heat your gun
  turn(degrees)       #turns the robot (and the gun and the radar), 
                      #max 10 degrees per tick
  turn_gun(degrees)   #turns the gun (and the radar), max 30 degrees per tick
  turn_radar(degrees) #turns the radar, max 60 degrees per tick
  dead                #true if you are dead
  say(msg)            #shows msg above the robot on screen
  broadcast(msg)      #broadcasts msg to all bots (they receive 'broadcasts'
                      #events with the msg and rough direction)

These methods are intentionally of very basic nature, you are free to
unleash the whole power of ruby to create higher level functions.
(e.g. move_to, fire_at and so on)

Some words of explanation: The gun is mounted on the body, if you turn
the body the gun will follow. In a similar way the radar is mounted on
the gun. The radar scans everything it sweeps over in a single tick (100 
degrees if you turn your body, gun and radar in the same direction) but
will report only the distance of scanned robots, not the angle. If you 
want more precision you have to turn your radar slower.
=end