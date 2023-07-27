#################### MAIN ####################
# get resolution / display size
import pyautogui
DISPLAY_SIZE_X, DISPLAY_SIZE_Y = pyautogui.size()
#################### MAIN ####################

#################### mouseMover ####################
# max time to sleep in seconds not allowed to be > 2 seconds
# otherwise we have too much idle time :)
MAX_TIMER = 5
# MAX x and y mouse movement pixels in one interation
MAX_PIXEL_X = range(-150, 150, 1)
MAX_PIXEL_Y = range(-150, 150, 1)
#################### mouseMover ####################
