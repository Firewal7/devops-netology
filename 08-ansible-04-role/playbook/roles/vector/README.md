Vector
=========

This role can install Vector for Clickhouse

Role Variables
--------------
| Variable  |      |
|:-----|:----|
| vector_version | Version of Vector to install |

Example Playbook
----------------

```yml
    - name: Install Vector
      hosts: servers
      roles:
        - vector
```

