from selenium import webdriver

def verifyLoginSuccess(driver: webdriver.Chrome) -> None:
    expectedTitle="Prometheus Time Series Collection and Processing Server"
    assert expectedTitle in driver.title
