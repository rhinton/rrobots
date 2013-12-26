# NetBot -- Shim to send events to a network server and wait for a response for
# commands.
#
# Ryan Hinton, 25 Dec 2013.


require 'rrobots/robot'
require 'socket'
#zmq:require 'ffi-rzmq'
require 'json'
require 'set'


class NetBot
  include Robot

  SERVER_IP = '10.0.0.185'
  SERVER_PORT = 5556
  #zmq:SERVER_ADDR = "tcp://#{SERVER_IP}:#{SERVER_PORT}"
  SERVER_ADDR = "tcp://#{SERVER_IP}:#{SERVER_PORT}"

  def initialize
    puts "NetBot commecting to [#{SERVER_ADDR}]"
    #zmq:@sock = ZMQ::Context.new.socket(ZMQ::PAIR)
    #zmq:@sock.connect(SERVER_ADDR)
    @sock = UDPSocket.new
    @sock.bind('0.0.0.0', SERVER_PORT)
    @sock.connect(SERVER_IP, SERVER_PORT)
    @msg_num = 0
  end


  def tick(events)
    sleep(1.0) if 0 == self.time
    send_setup if 0 == self.time
    sleep(1.0) if 0 == self.time
    #send_state
    send_events(events)
    cmds = recv_commands
    exec_commands(cmds)
  end


  SETUP_VARS = ['team', 'size', 'battlefield_height', 'battlefield_width']
  STATE_VARS = ['energy', 'gun_heading', 'gun_heat', 'heading', 'radar_heading', 'time', 
                'game_over', 'speed', 'x', 'y']
  ALLOWED_COMMANDS = Set.new(['fire', 'accelerate', 'turn', 'turn_gun', 'turn_radar'])


  def send_setup
    msg_hash = {}
    SETUP_VARS.each {|str| msg_hash[str] = self.send(str)}
    send_message(msg_hash)
  end

  #state:def send_state
  #state:  msg_hash = {}
  #state:  STATE_VARS.each {|str| msg_hash[str] = self.send(str)}
  #state:  send_message(msg_hash)
  #state:end

  def send_events(events)
    msg_hash = events.dup
    STATE_VARS.each {|str| msg_hash[str] = self.send(str)}
    send_message(msg_hash)
    #state:send_message(events)
  end

  def recv_commands
    recv_message
  end

  def exec_commands(cmds)
    cmds.each do |cmd, params|
      if ALLOWED_COMMANDS.include?(cmd)
        self.send(cmd, params)
      else 
        puts "Ignoring unauthorized command [#{cmd}]."
      end
    end
  end

  def send_message(hsh)
    hsh['message_num'] = @msg_num
    @msg_num += 1
    #dbg:puts "Sending [#{hsh.to_s}]."#DEBUG::
    #zmq:@sock.send_string(JSON.generate(hsh))
    #zmq:@sock.send(JSON.generate(hsh))
    @sock.send(JSON.generate(hsh), 0)
    #sleep(1.0e-3)
  end

  def recv_message
    #zmq:tmp = ''
    #zmq:rc = @sock.recv_string(tmp)
    #zmq:if tmp.empty? && (0 == rc)
    #zmq:  # getting blank message from Python right after connection established
    #zmq:  rc = @sock.recv_string(tmp)
    #zmq:end
    #zmq:if 0 != rc
    #zmq:  raise RuntimeError, "Received non-zero return code [#{rc}] from 0MQ."
    #zmq:end
    tmp, info = @sock.recvfrom(8192)
    #dbg:puts "Received [#{tmp}]."#DEBUG::
    return JSON.parse(tmp)
  end

end # class NetBot
