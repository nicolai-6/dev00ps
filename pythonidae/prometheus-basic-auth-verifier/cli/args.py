import argparse

# get command line arguments
def getArgs() -> dict:
    parser = argparse.ArgumentParser(description='login to prometheus frontend', add_help=True)
    parser.add_argument('--username', required=True, type=str, dest='prometheus_username', help='basic auth username')
    parser.add_argument('--password', required=True, type=str, dest='prometheus_password', help='basic auth password')
    parser.add_argument('--url', required=True, type=str, dest='prometheus_url', help='target url, status page of prometheus instance: https://prometheus-domain.com/status')
    parser.add_argument('--chromedriver-path', required=True, type=str, dest='chromedriver_path', help='path to the chromedriver binary, example: "/usr/local/bin/chromedriver"')
    cmdArgs = parser.parse_args()
    return {
        'username': cmdArgs.prometheus_username, 
        'password': cmdArgs.prometheus_password, 
        'url': cmdArgs.prometheus_url,
        'chromedriver_path': cmdArgs.chromedriver_path
    }
