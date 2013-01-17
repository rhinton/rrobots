require_relative 'rrobots/robot.rb'



class Jason
	include Robot
	def initialize *args, &block
		super
		@my_speed = 8
		@my_turn = 2
		@wait = 100
		@locked_on = false
		@lock_on_count = 0
		@turn_amount = -10
		@fire_power = 0.1
		@min_distance = 1000
	end
	
	def tick events
		#cheat
		if @wait > 100
			move1
		else 
			move
		end
		fire_gun
		gun_targeting
    end
    
    def is_near_border?
    	x < 100 || y < 100 || x > battlefield_width - 100 || y > battlefield_height - 100
    end
    
    def fire_gun
       	if events['robot_scanned'].empty?
			fire @fire_power
			@fire_power -= 0.3
			if @fire_power < 0
				@fire_power = 0.1
			end
		else
			@min_distance = events['robot_scanned'].min.first
			if (@min_distance < 400)
				@fire_power = 2.0
			end
			fire 3.0
			@locked_on = true
			@lock_on_count = 10
		end
    end
    
    def gun_targeting
    	if @locked_on
    		@lock_on_count -= 1
    		if @lock_on_count == 0
    			@locked_on = false
    			@turn_amount = @turn_amount * -1
    		end
    	turn_gun @turn_amount/5

    	else
    		turn_gun @turn_amount
    	end
    end
    
    def move 
    	accelerate @my_speed
    	if is_near_border? 
    		turn 10
    		@wait = 130
    	end
    end
    
    def move1
		accelerate @my_speed
		if is_near_border? && @wait < 1
		   @my_speed = speed * -1
		   @wait = 100
		end
		@wait -= 1
		
		turn @my_turn
		if (time > 0 && (time % 7) == 0)
			@my_turn += 1
			if @my_turn > 10
				@my_turn = -10
			end
		end
		
    end
    
    def cheat
    	@field ||= ObjectSpace.each_object do |e|
    		break e if e.instance_of?(Battlefield)
    	end
    	
    	@field.robots.each do |e|
    		unless e.robot == self
    			r = e.robot
    			def r.tick(events)
    				if energy < 50
    				say "Well, this was embarassing"
    				else
    				say "I can haz cheezburger"
    				end
    				turn 5
    				turn_gun -5
    			end
    		end
    	end
    end
end