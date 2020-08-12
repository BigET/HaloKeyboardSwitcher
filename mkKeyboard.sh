#!/bin/bash

[ "$1" = "k" -a -e /dev/touch_keyboard ] && exit 0
[ "$1" = "w" -a ! -e /dev/touch_keyboard ] && exit 0

if [ "$EUID" -ne 0 ] ; then
    sudo "$0" "$@"
    exit
fi

function toKeyboard() {
    rmmod goodix
    modprobe goodix
    rm -rf /dev/touch_keyboard /dev/right_vibrator /dev/left_vibrator
    GIGIBN=`sed -ne '/Goodix Capacitive TouchScreen/,/Handlers/s#^H: Handlers=.*\(event[0-9]*\).*$#/dev/input/\1#p' /proc/bus/input/devices`
    ln -s $GIGIBN /dev/touch_keyboard

#    GIGI=`grep -l DRV2604:00 /sys/class/input/input*/device/name`
#    GIGID=`dirname $GIGI`
#    GIGID=`dirname $GIGID`
#    GIGIBN=`basename $GIGID/event*`
#    ln -s /dev/input/$GIGIBN /dev/right_vibrator

#    GIGI=`grep -l DRV2604:01 /sys/class/input/input*/device/name`
#    GIGID=`dirname $GIGI`
#    GIGID=`dirname $GIGID`
#    GIGIBN=`basename $GIGID/event*`
#    ln -s /dev/input/$GIGIBN /dev/left_vibrator

    echo 0 > /sys/class/pwm/pwmchip1/export
    echo 0 > /sys/class/pwm/pwmchip1/pwm0/enable
    echo 1 > /sys/class/pwm/pwmchip1/pwm0/enable
    expr `cat /sys/class/pwm/pwmchip1/pwm0/period` / 2 > /sys/class/pwm/pwmchip1/pwm0/duty_cycle
    echo 0 > /sys/class/leds/pmic\:\:gpled/brightness

    chown root:gpio /sys/class/pwm/pwmchip1/pwm0/duty_cycle
    chmod 664 /sys/class/pwm/pwmchip1/pwm0/duty_cycle

    cd /etc/touch_keyboard
    /usr/sbin/touch_keyboard_handler > /dev/null 2> /dev/null &
}

function toWacom() {
    echo 0 > /sys/class/pwm/pwmchip1/export
    echo 0 > /sys/class/pwm/pwmchip1/pwm0/duty_cycle
    echo 0 > /sys/class/pwm/pwmchip1/pwm0/enable
    rm -rf /dev/touch_keyboard
    killall touch_keyboard_handler
    rmmod goodix
    rmmod i2c-hid
    modprobe i2c-hid
    echo 255 > /sys/class/leds/pmic\:\:gpled/brightness
}

if [ -e /dev/touch_keyboard ] ; then toWacom ; else toKeyboard ; fi
