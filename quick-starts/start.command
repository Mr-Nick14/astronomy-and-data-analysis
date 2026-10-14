#!/bin/bash
# Double-click this file on macOS (Finder).
cd "$(dirname "$0")" || exit 1
bash "./start.sh"
result=$?
if [ "$result" -ne 0 ]; then
  echo
  read -r -p "Press Enter to close this window..." _
fi
exit "$result"
