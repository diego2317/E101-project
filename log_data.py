#!/usr/bin/env python3

import sys
import time
import serial  # pip install pyserial

SERIAL_PORT = "/dev/ttyACM0"   # change as needed
BAUD_RATE   = 115200
OUTFILE     = "comb_filter.csv"
TIMEOUT_S   = 0.01
DURATION_S  = 2.0


def open_serial(port: str, baud: int, timeout: float) -> serial.Serial:
    try:
        return serial.Serial(port=port, baudrate=baud, timeout=timeout)
    except serial.SerialException as e:
        print(f"Error opening serial port {port}: {e}", file=sys.stderr)
        sys.exit(1)


def main():
    ser = open_serial(SERIAL_PORT, BAUD_RATE, TIMEOUT_S)
    time.sleep(2.0)
    ser.reset_input_buffer()
    rows = []  # store full lines as received (already "xn;yn")

    start_time = time.time()

    try:
        while (time.time() - start_time) < DURATION_S:
            line_bytes = ser.readline()
            if not line_bytes:
                continue

            line = line_bytes.decode("ascii", errors="ignore").strip()
            if not line:
                continue

            rows.append(line)

    finally:
        ser.close()

    with open(OUTFILE, "w", buffering=1024 * 1024) as f:
        f.write("pulse;butterworth;filter\n")   # no trailing ';'
        f.write("\n".join(rows))
        f.write("\n")

    print(f"Wrote {len(rows)} samples to {OUTFILE}")


if __name__ == "__main__":
    main()
