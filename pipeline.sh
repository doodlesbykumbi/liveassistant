#!/usr/bin/env bash
set -eo pipefail

calculating=false
echo "initialising..."
echo "start by saying 'calculate'"
gst-launch-1.0 -q osxaudiosrc ! audioconvert ! audioresample ! audio/x-raw,channels=1,rate=16000 ! filesink location=/dev/stdout | ./out/liveassistant | while IFS='$\n' read -r line; do
    if echo "$line" | grep -q "calculate"; then
      calculating=true
      echo "waiting for instructions to calculate..."
    elif echo "$line" | grep -q "stop"; then
      calculating=false
      echo "stopped calculating"
    elif $calculating; then
      echo "$line = ""$(python -c "print($line)")"
    fi
done
