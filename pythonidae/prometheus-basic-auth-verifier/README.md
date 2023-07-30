# simple cli app that verifies that a prometheus frontend is secured with basic auth credentials

## RUNBOOK
    python3 -m venv .prometheus_basic_auth_verifier 
    source .prometheus_basic_auth_verifier/bin/activate
    python3 -m pip install --upgrade pip
    pip install -r requirements.txt

    # usage:
    usage: python3 check_basic_auth.py --username USERNAME --password PASSWORD --url http(s)://prometheus.domain.com/status --chromedriver-path "/path/to/chromedriver"
    # NOTE: --url has to point to prometheus status page!
