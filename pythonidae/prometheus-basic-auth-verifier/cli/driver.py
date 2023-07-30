from selenium import webdriver
from selenium.webdriver.chrome.service import Service

# create browser instance
def createSession(url: str, driver_path: str) -> webdriver.Chrome:
    service = Service(executable_path=driver_path)
    options = webdriver.ChromeOptions()
    driver = webdriver.Chrome(service=service, options=options)
    driver.get(url)

    return driver
