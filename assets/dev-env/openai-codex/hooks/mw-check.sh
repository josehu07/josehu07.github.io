#!/usr/bin/env bash

# Codex passes hook context on stdin for this event; this check only needs the
# local Midway session state.

# If no mwinit exists, ignore the check.
if ! command -v mwinit >/dev/null 2>&1; then
    exit 0
fi

output=$(mwinit -l 2>&1)

if printf '%s\n' "$output" | grep -q '\.midway/cookie$'; then
    # Do not print anything extra on success.
    exit 0
fi

if printf '%s\n' "$output" | grep -q "Public RSA certificate expired or not found"; then
    printf '\n' >&2
    printf 'No active Midway sessions found, please run: mwinit -s -o\n' >&2
    exit 2
fi

printf '\n' >&2
printf 'Unable to determine Midway sessions status, please run: mwinit -s -o\n' >&2
exit 2
