from cli import args, driver, login, verify
import time

# main
def main():
    # get cli args
    cliArgs = args.getArgs()
    username = cliArgs['username']
    password = cliArgs['password']
    target_url = cliArgs['url']
    driver_path = cliArgs['chromedriver_path']

    # websession
    browser_instance = driver.createSession(target_url, driver_path)
    # authenticate
    login.sendLogin(browser_instance, username, password)
    time.sleep(5)
    # verify
    verify.verifyLoginSuccess(browser_instance)
    
    browser_instance.quit()

if __name__ == '__main__':
    main()
