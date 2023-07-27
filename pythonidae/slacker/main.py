from constants import *
from random import randint
from mouseMover.mouseMover import MouseMover

def main():
    while True:
        x_move = randint(MAX_PIXEL_X.start, MAX_PIXEL_X.stop)
        y_move = randint(MAX_PIXEL_Y.start, MAX_PIXEL_Y.stop)
        cooldown = randint(0, MAX_TIMER)  
        
        mover = MouseMover(cooldown)
        mover.move(x_move, y_move)
        mover.cooldown()

if __name__ == "__main__":
    main()
