"""
Invoke like:

python pyrobot.py '0.0.0.0:5556'
"""

import json
import random

SETUP_VARS = ('team', 'size', 'battlefield_height', 'battlefield_width')
STATE_VARS = ('energy', 'gun_heading', 'gun_heat', 'heading', 'heading', 
              'radar_heading', 'time', 'game_over', 'speed', 'x', 'y')

class PyRobot(object):
    def __init__(self, socket):
        self.socket = socket
        self.get_setup()

    def get_setup(self):
        msg = self.socket.recv_msg()
        try:
            for k in SETUP_VARS:
                setattr(self, k, msg[k])

        except:
            print "problem setting initial setup"

    def turn(self):
        state = self.socket.recv_msg()
        commands = self.tick(state)
        if state['game_over']:
            return False
        self.socket.send_msg(commands)
        return True
    
    def tick(self, state):
        """
        This is the function to override in subclasses
        The return value should be a dictionary with the allowed commands:
        fire, accelerate, turn, turn_gun, turn_radar
        """
        return {'fire': .1, 'turn_gun': 7, 'accelerate':random.uniform(-2,2), 'turn': random.uniform(-10,10)}

class Socket(object):
    def send_msg(self, msg):
        raise NotImplementedError
    def recv_msg(self, msg):
        raise NotImplementedError
        
class ZMQSocket(Socket):
    def __init__(self, address):
        self.context = zmq.Context()
        self.socket = self.context.socket(zmq.PAIR)
        self.socket.bind(address)
        
    def send_msg(self, msg):
        print 'sending:',msg
        self.socket.send(json.dumps(msg))

    def recv_msg(self):
        msg = json.loads(self.socket.recv())
        print 'received',msg
        return msg
    
import socket
class UDPSocket(Socket):
    def __init__(self, address):
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        addr, port = address.split(':')
        port = int(port)
        print 'binding to', (addr, port)
        self.socket.bind((addr, port))

    def send_msg(self, msg):
        print "sending to", self.addr, "message", msg
        self.socket.sendto(json.dumps(msg), self.addr)

    def recv_msg(self):
        data, addr = self.socket.recvfrom(8*1024)
        self.addr = addr
        msg = json.loads(data)
        print "received",msg
        return msg

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('address', help='address to bind')
    args = parser.parse_args()
    p = PyRobot(UDPSocket(args.address))
    while p.turn():
        pass
