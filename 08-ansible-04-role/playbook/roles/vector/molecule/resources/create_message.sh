#!/bin/bash

set -o pipefail && echo "debug message" | nc -w 1 127.0.0.1 6767
