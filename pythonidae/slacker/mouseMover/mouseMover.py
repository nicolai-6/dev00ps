import sys
import os.path
# append one path upper to syspath for constants import
sys.path.append(
    os.path.abspath(os.path.join(os.path.dirname(__file__), os.path.pardir)))
from constants import *

import pyautogui
import time

class MouseMover:
    def __init__(self, random_pause: int):
        self.random_pause = random_pause

    @property
    def random_pause(self) -> int:
        print("Getting random pause in seconds...")
        return self.random_pause

    @random_pause.setter
    def random_pause(self, s) -> None:
        if s > MAX_TIMER:
            raise ValueError(f"maximum pause in seconds must not exceed {MAX_TIMER}")
        self._random_pause = s

    def move(self, x: int, y: int) -> str:
        # get current mouse x y
        x_now, y_now = pyautogui.position()

        # move mouse only if new position is not out of resolution and > 0
        if (x_now+x <= DISPLAY_SIZE_X and
            y_now+x > 0 and
            y_now+y <= DISPLAY_SIZE_Y and
            y_now+y > 0 ):
                pyautogui.moveTo(x_now+x, y_now+y)
                return print(f"moved to position:\nx: {x_now+x}\ny: {y_now+y}")
        return print(f"target mouse position out of resolution!\nx: {x_now+x}\ny: {y_now+y}")

    def cooldown(self, p=None) -> str:
        if p is None:
            p = self._random_pause
            time.sleep(p)
        return print(f"slept for: {p} seconds")
