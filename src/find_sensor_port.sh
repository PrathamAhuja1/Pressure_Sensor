#!/bin/bash
echo "Scanning all serial ports..."
for PORT in /dev/ttyS{0..31}; do
  [ -e "$PORT" ] || continue
  echo "Testing $PORT..."
  for BAUD in 9600 19200 38400 57600 115200; do
    sudo stty -F "$PORT" "$BAUD" cs8 -cstopb -parenb raw -echo 2>/dev/null
    DATA=$(timeout 2 cat "$PORT" 2>/dev/null)
    if echo "$DATA" | grep -q "/"; then
      echo "✓ FOUND on $PORT at $BAUD baud!"
      echo "Data sample: $DATA" | head -3
      echo ""
      echo "Run with: ros2 run depth_sensor_pkg depth_sensor_node --ros-args -p serial_port:=$PORT -p baud_rate:=$BAUD"
      exit 0
    fi
  done
done
echo "No sensor found. Is it connected?"
