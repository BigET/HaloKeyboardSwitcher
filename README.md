# HaloKeyboardSwitcher
A script to switch between halo keyboard and wacom digitizer.

This script will do all the loops jumping to activate either the watcom (and
the pen led) or the halo keyboard (and the halo backlight).

It is using the chromiumos_touch_keyboard module to do the virtual keyboard.

# How do I use it.

in /etc/rc.local

call mkKeyboard with the "k" parameter to make sure it will switch to the keyboard mode.

    /usr/local/bin/mkKeyboard.sh k 2> /dev/null > /dev/null &

bin the power button to the keyboard switcher.

    /usr/local/bin/pwBut.sh /usr/local/bin/mkKeyboard.sh 2> /dev/null > /dev/null &
