#!/bin/bash

# if no mwinit, ignore the check
if ! command -v mwinit >/dev/null 2>&1; then
    exit 0
fi

output=$(mwinit -l 2>&1)

if echo "$output" | grep -q '\.midway/cookie$'; then
    # don't print anything extra -- any output is considered hook failure
    exit 0
fi

if echo "$output" | grep -q "Public RSA certificate expired or not found"; then
    echo "" 1>&2
    echo "No active Midway sessions found, please run: mwinit -s -o" 1>&2
    exit 2  # blocking error
fi

echo "" 1>&2
echo "Unable to determine Midway sessions status, please run: mwinit -s -o" 1>&2
exit 2  # blocking error
