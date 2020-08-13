#!/bin/sh

EVNR=`sed -ne '/^N: Name="gpio-keys"$/,/^$/{
s/^H: Handlers=kbd event\(.*\)$/\1/
t saveEV
s/^B: EV=3$//
t printEV
}
b
:saveEV
h
b
:printEV
g
p
q' /proc/bus/input/devices`

evtest --grab /dev/input/event$EVNR | while read LINE ; do
case "$LINE" in
(*value\ 1) "$@" ;;
esac
done
