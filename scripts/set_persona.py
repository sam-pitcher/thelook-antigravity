#!/usr/bin/env python3
"""
Switch the persona of user 'shredr looker' (User ID 3) dynamically.

Usage:
  python3 scripts/set_persona.py marketing
  python3 scripts/set_persona.py finance
  python3 scripts/set_persona.py executive
  python3 scripts/set_persona.py admin
"""

import sys
import json
import urllib.request
import ssl
import os
import re

PERSONAS = {
    "marketing": {
        "role_id": "48",
        "role_name": "Marketing Analyst Role",
        "can_see_pii": "No",
        "description": "Marketing Spoke only, PII masked (can_see_pii = No)"
    },
    "finance": {
        "role_id": "49",
        "role_name": "Finance Auditor Role",
        "can_see_pii": "Yes",
        "description": "Finance Spoke only, PII visible (can_see_pii = Yes)"
    },
    "executive": {
        "role_id": "50",
        "role_name": "Executive Role",
        "can_see_pii": "No",
        "description": "Official Core Sales only, clean executive view"
    },
    "admin": {
        "role_id": "2",
        "role_name": "Admin",
        "can_see_pii": "Yes",
        "description": "Full unrestricted access across all models"
    }
}

def main():
    if len(sys.argv) < 2 or sys.argv[1].lower() not in PERSONAS:
        print(f"Usage: python3 {sys.argv[0]} [marketing|finance|executive|admin]")
        sys.exit(1)

    target_persona = sys.argv[1].lower()
    config = PERSONAS[target_persona]

    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE

    with open(os.path.expanduser("~/.config/looker-cli/config.yaml")) as f:
        text = f.read()

    token_match = re.search(r"argolis:.*?(?:token|access-token):\s*([^\s]+)", text, re.DOTALL)
    token = token_match.group(1) if token_match else re.search(r"token:\s*([^\s]+)", text).group(1)
    host = "915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app"
    port = "443"
    headers = {"Authorization": f"token {token}", "Content-Type": "application/json"}

    user_id = "3"

    # 1. Update Role
    role_req = urllib.request.Request(
        f"https://{host}:{port}/api/4.0/users/{user_id}/roles",
        data=json.dumps([config["role_id"]]).encode("utf-8"),
        headers=headers,
        method="PUT"
    )
    urllib.request.urlopen(role_req, context=ctx)

    # 2. Update PII Attribute
    attr_req = urllib.request.Request(
        f"https://{host}:{port}/api/4.0/users/{user_id}/attribute_values/17",
        data=json.dumps({"value": config["can_see_pii"]}).encode("utf-8"),
        headers=headers,
        method="PATCH"
    )
    urllib.request.urlopen(attr_req, context=ctx)

    print(f"✅ Successfully switched user 'shredr looker' (ID {user_id}) to [{target_persona.upper()}] persona!")
    print(f"   • Assigned Role: {config['role_name']} (Role ID {config['role_id']})")
    print(f"   • PII Access (`can_see_pii`): {config['can_see_pii']}")
    print(f"   • Description: {config['description']}\n")
    print(f"👉 You can now Sudo as 'shredr looker' in Looker UI:")
    print(f"   https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/admin/users")

if __name__ == "__main__":
    main()
