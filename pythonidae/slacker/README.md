# simple mouse mover that prevents any collaboration tool from changing status to "away" :)
    - includes some fixes to never reach the borders of the display (resolution) 
    -> otherwise could make "pyautogui" package crash
    - includes some fixes for multi monitor usage (still maybe only runs with one active display, depending on the OS)

## RUNBOOK
    python3 -m venv .slacker
    source .slacker/bin/activate
    python3 -m pip install --upgrade pip
    pip install -r requirements.txt

- optionally adjust constants.py
- install requirements and run main.py
