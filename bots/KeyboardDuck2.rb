require 'rrobots/robot.rb'
require 'gosu'

class KeyboardDuck2
  include Robot

  def tick(events)
    #unless (dist = events['robot_scanned']).empty?
    #  say 'ENEMY SPOTTED ' + (dist.first.first / 2).to_i.to_s + ' PIXELS AWAY!'
    #end
    
    #unless events['got_hit'].empty?
    #  say 'OUCH!'
    #end

    if $window.button_down?(Gosu::KbDown)
        accelerate -3
    end
    if $window.button_down?(Gosu::KbUp)
        accelerate 3
    end
    if $window.button_down?(Gosu::KbRight)
        turn -4
    end
    if $window.button_down?(Gosu::KbLeft)
        turn 4
    end
    if $window.button_down?(Gosu::KbZ)
        turn_gun 4
    end
    if $window.button_down?(Gosu::KbX)
        turn_gun -4
    end
    if $window.button_down?(Gosu::KbSpace)
        fire 0.3
    end
  end
end
