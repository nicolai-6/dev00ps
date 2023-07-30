from selenium import webdriver
from pynput.keyboard import Key, Controller

def sendLogin(driver: webdriver.Chrome, un: str, pw: str) -> None:
    keyboard = Controller()
    keyboard.type(un)
    keyboard.press(Key.tab)
    keyboard.type(pw)
    keyboard.press(Key.enter)
