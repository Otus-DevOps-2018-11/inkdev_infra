#!/usr/bin/python
import json
import subprocess
import os
os.chdir('../terraform/stage/')
output = subprocess.check_output(['terraform', 'output', '-json'])
j =json.loads(output)
for i in j:
    app_ip = j['app_external_ip']['value']
    db_ip = j['db_external_ip']['value']
#print(app_ip)
#print(db_ip)

out = {
    "_meta": {
        "hostvars": {
            "appserver": {
                "ansible_host": app_ip
            },
            "dbserver": {
                "ansible_host": db_ip
            }
        }
    },
    "all": {
        "children": [
            "app",
            "db"
        ]
    },
    "app": {
        "hosts": [ "appserver" ]
    },
    "db": {
        "hosts": [ "dbserver" ]
    }
}

print(json.dumps(out))