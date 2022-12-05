#!/bin/bash
#  PROBLEM: sometimes things go to sleep when you step away & long-running scripts can break - this is my workaround!
# ABSTRACT: quick & dirty script to periodically jiggle the mouse 
#  CREATED: 2022-DEC05JN - first try 
# REQUIRES: Linux Input Event-Device Emulation Library (apt install evemu-tools) which needs to be run as root.
#    NOTES: Libevdev abstracts the evdev ioctls through type-safe interfaces & made available via /dev/input
#           From man page - "evemu-event plays exactly one event with the current time. 
#               If --sync is given, evemu-event generates an EV_SYN event after the event. 
# SEE-ALSO: https://www.kernel.org/doc/Documentation/input/event-codes.txt - for low-level details

_mouse_=$(ls -1 /dev/input/by-id/*event-mouse | tail -1)
[ -z "${_mouse_}" ] && echo " FATAL ERROR: mouse-event interface NOT found in /dev/input" && exit 1
echo "Using ${_mouse_}"
while [ true ]; do # get jiggy wit dat sh!
        sleep 60
        /usr/bin/evemu-event ${_mouse_} --type EV_REL --code REL_X --value 1 --sync
        /usr/bin/evemu-event ${_mouse_} --type EV_REL --code REL_X --value -1 --sync
        echo -n "#"
done