#!/usr/bin/env python3
# app_health_check.py
import requests, sys, time

URL = sys.argv[1] if len(sys.argv)>1 else "http://localhost:4499"
TO=5
try:
    r = requests.get(URL, timeout=TO)
    status = r.status_code
    if 200 <= status < 300:
        print(f"OK {status} - {URL}")
        sys.exit(0)
    else:
        print(f"DOWN {status} - {URL}")
        sys.exit(2)
except Exception as e:
    print(f"ERROR - {e}")
    sys.exit(2)

